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

    if args.verbose:
        print('COMMAND:', ' '.join(cmd))
    result = subprocess.run(cmd, stdout=subprocess.PIPE)
    lines = result.stdout.decode('utf-8').split('\n')
    # lines = open('sacct.txt').readlines()

    top_n = args.n

    users = defaultdict(int)
    projs = defaultdict(int)
    no_gres = defaultdict(int)

    for line in lines:
        if len(line) == 0:
            continue
        user, account, elapsed, nnodes, allocgres = line.rstrip().split('|')
        elapsed = int(elapsed)
        nnodes = int(nnodes)
        if len(allocgres) > 0:
            allocgres = dict([x.split(':') for x in allocgres.split(',')])
            gpus = int(allocgres['gpu'])
        else:
            if elapsed > 0:
                no_gres[user] += elapsed*nnodes
            gpus = 1

        gpu_secs = elapsed*nnodes*gpus
        users[user] += gpu_secs
        projs[account] += gpu_secs

    title = "Top {} {} according to total GPU seconds".format(top_n, args.mode)
    if args.S:
        title += " from " + args.S
    if args.E:
        title += " to "+ args.E
    print(title)
    
    if args.mode == 'users':
        for user, secs in sorted(users.items(), key=lambda x: -x[1])[:top_n]:
            print(user, secs)

        if len(no_gres) > 0:
            print('\nWARNING: the following users have run without gres!')
            for user, secs in no_gres.items():
                print(user, secs)
    elif args.mode == 'projects':
        for proj, secs in sorted(projs.items(), key=lambda x: -x[1])[:top_n]:
            print('{:15} {:10d} {}'.format(proj, secs, get_proj_desc(proj)))


if __name__ == '__main__':
    now = datetime.now()
    start_month = now.strftime("%Y-%m-01")

    parser = argparse.ArgumentParser(description='')
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
    main(parser.parse_args())
