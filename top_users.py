#!/usr/bin/env python3

import argparse
import os
import subprocess
import sys
from collections import defaultdict
from datetime import datetime


def get_proj_info(proj, proj_map, disable_call=False):
    if not disable_call:
        result = subprocess.run(['csc-projects',  '-p', proj, '-o', 'P,T'],
                                stdout=subprocess.PIPE)
        pi_name, desc = result.stdout.decode('utf-8').rstrip().split(',', 1)
    else:
        pi_name, desc = '', ''
    fcai = False
    aff = None
    if proj_map and proj in proj_map:
        aff = proj_map[proj].lower()
        if 'aalto' in aff or 'vtt' in aff or 'helsinki' in aff:
            fcai = True
    return pi_name, desc, aff, fcai


def get_proj_mapping():
    fn = 'projects.txt'
    if not os.path.exists(fn):
        return None

    proj_map = {}
    with open(fn) as fp:
        for line in fp:
            proj_num, affiliation = line.rstrip().split(':', 1)
            proj_map[proj_num] = affiliation.strip()
    return proj_map


def main(args):
    proj_map = get_proj_mapping()

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

    title = "Top {}".format(args.n) if args.n else "All"
    title += " {} according to total GPU hours".format(args.mode)
    if args.S:
        title += " from " + args.S
    if args.E:
        title += " to " + args.E
    print(title)

    out = sys.stdout
    use_csv = False
    if args.output:
        out = open(args.output, 'w')
        use_csv = True

    if args.mode == 'users':
        sorted_users = sorted(users.items(), key=lambda x: -x[1])
        if args.n:
            sorted_users = users[:args.n]
        for user, hours in sorted_users:
            if use_csv:
                print(user, hours, file=out, sep=',')
            else:
                print('{:10} {:10.0f}'.format(user, hours), file=out)

        if len(no_gres) > 0:
            print('\nWARNING: the following users have run without GPUs!',
                  file=sys.stderr)
            for user, hours in no_gres.items():
                print('{:10} {:10.0f}'.format(user, hours), file=sys.stderr)
    elif args.mode == 'projects':
        sorted_projs = sorted(projs.items(), key=lambda x: -x[1])
        if args.n:
            sorted_projs = sorted_projs[:args.n]
        aff_sums = defaultdict(float)
        ml_hours = 0.0
        all_hours = 0.0
        for proj, hours in sorted_projs:
            pi_name, desc, aff, fcai = get_proj_info(proj, proj_map,
                                                     args.no_project_info)
            all_hours += hours
            if aff:
                ml_hours += hours
                aff_sums[aff] += hours
                if fcai:
                    aff_sums['fcai'] += hours
            else:
                aff = '?'
            if use_csv:
                print(proj, hours, pi_name, aff, desc, file=out, sep=',')
            else:
                print('{:15} {:8.0f} {}, {}, {}'.format(proj, hours, pi_name,
                                                        aff, desc), file=out)

        print('\nML hours: {:.0f}/{:.0f} ({:.2%})'.format(ml_hours, all_hours,
                                                          ml_hours/all_hours))
        print('\nML projects per affiliation:')
        for aff, hours in sorted(aff_sums.items(), key=lambda x: -x[1]):
            print('{:10} {:8.0f} ({:.2%})'.format(aff, hours, hours/ml_hours))

    if args.output:
        out.close()


if __name__ == '__main__':
    now = datetime.now()
    start_month = now.strftime("%Y-%m-01")

    parser = argparse.ArgumentParser()
    parser.add_argument('mode', choices=['users', 'projects'])
    parser.add_argument('-n', type=int, help='number of top results to show')
    parser.add_argument('-p', '--partition', default='gpu',
                        help='partition to show')
    parser.add_argument('-S', default=start_month,
                        help='start time for jobs, given to sacct, '
                        'default: start of current month')
    parser.add_argument('-E', help='end time for jobs, given to sacct')
    parser.add_argument('-v', '--verbose', action='store_true')
    parser.add_argument('-f', '--file',
                        help='read sacct output from file instead')
    parser.add_argument('-o', '--output', help='write output to file')
    parser.add_argument('--no_project_info', action='store_true',
                        help='disable fetching of project info')
    main(parser.parse_args())
