import logging
import json
import argparse

import requests

github_base = "https://api.github.com"
github_status_url = github_base + "/repos/{repo_name}/statuses/{sha}?access_token={token}"

token = '7d8e55146533600c773d6557e7e4ae93ec723fb9'


def update_status(repo_name, sha, state, desc='Airflow CI Tests', target_url=None):

    url = github_status_url.format(repo_name=repo_name, sha=sha, token=token)
    params = dict(state=state, description=desc)

    if target_url:
        params["target_url"] = target_url

    headers = {"Content-Type": "application/json"}

    logging.debug("Setting status on %s %s to %s", repo_name, sha, state)

    requests.post(url, data=json.dumps(params), headers=headers)


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Set github status')
    parser.add_argument('--repo', required=True, help="user/repo")
    parser.add_argument('--sha', required=True)

    def status_type(status):
        if status in ('pending', 'success', 'error', 'failure'):
            return status
        raise ValueError()

    parser.add_argument('--status', type=status_type, required=True)
    parser.add_argument('--url', help="Job url")

    args = parser.parse_args()

    update_status(args.repo, args.sha, args.status, target_url=args.url)
