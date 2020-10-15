#!/usr/bin/env python3

import argparse
import subprocess
from collections import defaultdict
from datetime import datetime


def get_proj_desc(proj):
    result = subprocess.run(['csc-projects',  '-p', proj, '-o', 'P,T'],
                            stdout=subprocess.PIPE)
    return result.stdout.decode('utf-8').rstrip()

def main(args):
    cmd = ['sacct',
           '-a',  # all users
           '-P',  # parsable
           '-X',  # only job allocation stats, not individual steps
           '-n',  # no header
           '--format', 'User,Account,elapsedraw,nnodes,allocgres']
    if args.S:
        cmd += ['-S', args.S]
    if args.E:
        cmd += ['-E', args.E]
    if args.partition:
        cmd += ['-r', args.partition]

    if args.file:
        if args.verbose:
            print('Reading sacct output from file', args.file)
        lines = open(args.file).readlines()
    else:
        if args.verbose:
            print('COMMAND:', ' '.join(cmd))
        result = subprocess.run(cmd, stdout=subprocess.PIPE)
        lines = result.stdout.decode('utf-8').split('\n')

    top_n = args.n

    users = defaultdict(float)
    projs = defaultdict(float)
    no_gres = defaultdict(float)

    for line in lines:
        if len(line) == 0:
            continue
        user, account, elapsed, nnodes, allocgres = line.rstrip().split('|')
        elapsed = int(elapsed)
        nnodes = int(nnodes)
        gpus = 0
        if len(allocgres) > 0:
            gres = dict([x.split(':') for x in allocgres.split(',')])
            if 'gpu' in gres:
                gpus = int(gres['gpu'])

        if gpus == 0 and elapsed > 0:
            no_gres[user] += elapsed*nnodes

        gpu_hours = elapsed*nnodes*gpus/60.0/60.0
        users[user] += gpu_hours
        projs[account] += gpu_hours

    title = "Top {} {} according to total GPU hours".format(top_n, args.mode)
    if args.S:
        title += " from " + args.S
    if args.E:
        title += " to "+ args.E
    print(title)
    
    if args.mode == 'users':
        for user, hours in sorted(users.items(), key=lambda x: -x[1])[:top_n]:
            print('{:10} {:10.0f}'.format(user, hours))

        if len(no_gres) > 0:
            print('\nWARNING: the following users have run without GPUs!')
            for user, hours in no_gres.items():
                print('{:10} {:10.0f}'.format(user, hours))
    elif args.mode == 'projects':
        for proj, hours in sorted(projs.items(), key=lambda x: -x[1])[:top_n]:
            print('{:15} {:8.0f} {}'.format(proj, hours, get_proj_desc(proj)))


if __name__ == '__main__':
    now = datetime.now()
    start_month = now.strftime("%Y-%m-01")

    parser = argparse.ArgumentParser()
    parser.add_argument('mode', choices=['users', 'projects'])
    parser.add_argument('-n', type=int, default=20,
                        help='number of top results to show')
    parser.add_argument('-p', '--partition', default='gpu',
                        help='partition to show')
    parser.add_argument('-S', default=start_month,
                        help='start time for jobs, given to sacct, '
                        'default: start of current month')
    parser.add_argument('-E', help='end time for jobs, given to sacct')
    parser.add_argument('-v', '--verbose', action='store_true')
    parser.add_argument('-f', '--file', help='read sacct output from file instead')
    main(parser.parse_args())
