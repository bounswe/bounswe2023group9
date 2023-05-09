import requests
import re
from django.http import JsonResponse
import urllib.parse
import json
from . import api_keys


def google_scholar(request):
    number = request.GET.get("rows")
    search = request.GET.get("title")
    if search == None or search == "":
        return JsonResponse({'status': 'Title to search must be given.'}, status=404)
    if number == None or number == "" or not number.isnumeric():
        number = 5
    else:
        number = int(number)

    request = requests.get('https://serpapi.com/search.json?engine=google_scholar&q=' +
                           search + '&hl=en&num=' + str(number) + '&api_key=' + api_keys.api_keys['serp_api'])
    if request.status_code == 200:
        request = request.json()
        papers = request['organic_results']
        response = {}
        results = []
        for paper in papers:
            pub_info = paper['publication_info']
            paper_info = {}
            paper_info['source'] = 'google_scholar'

            if 'authors' in pub_info.keys():
                paper_info['authors'] = []
                for author in pub_info['authors']:
                    a = {'name': author['name']}
                    paper_info['authors'].append(a.copy())
            else:
                temp = pub_info['summary'].split('-')[0].strip()
                temp = temp.split(',')
                authors = []
                for i in temp:
                    i = i.strip()
                    author = {}
                    author['name'] = i
                    authors.append(author.copy())
                paper_info['authors'] = authors

            paper_info['id'] = paper['result_id']
            summary = pub_info['summary']
            summary = '-' + summary + '-'
            year = re.findall('[\W|\s](\d{4})[\W|\s]', summary)
            if len(year) == 0:
                year = None
                paper_info['date'] = 'Not found'
            else:
                year = int(year[0])
                paper_info['date'] = year

            paper_info['abstract'] = paper['snippet']
            paper_info['title'] = paper['title']
            paper_info['url'] = paper['link']
            paper_info['pos'] = paper['position']
            results.append(paper_info.copy())
        response['results'] = results
        return JsonResponse(response)
    elif request.status_code == 404:
        return JsonResponse({'status': 'Unsuccessful Search.'}, status=404)
    else:
        return JsonResponse({'status': 'An internal server error has occured. Please try again.'}, status=503)


# this method sends requests to CORE API and fetches the response
def searchPaperOnCore(keyword, limit):
    headersCore = {"Authorization": "Bearer " +
                   api_keys.api_keys['core_api']}  # insert api key to header

    params = {'q': keyword, 'limit': limit}
    url = "https://api.core.ac.uk/v3/search/works?" + \
        urllib.parse.urlencode(params)

    req = requests.get(url, headers=headersCore)

    result = {'status_code': req.status_code, 'results': []}

    if req.status_code == 200:  # if request successful
        resp = json.loads(req.content.decode("UTF-8"))
        for i, r in enumerate(resp["results"]):
            authors = []
            for a in r['authors']:
                authors.append(a['name'])

            res_dic = {
                'title': r['title'],
                'authors': authors,
                'source': "core.ac.uk",
                'id': r['id'],
                'date': r['publishedDate'],
                'url': r['downloadUrl'],
                'position': i,
                'abstract': r['abstract']
            }

            result['results'].append(res_dic)

    return result


def core_get(request):  # this method parses the parameters of given get request which will use the CORE API and gives the necessary response
    keyword = request.GET.get("keyword")
    limit = request.GET.get("limit")

    if keyword == None or keyword == "":  # if no keyword param or empty
        return JsonResponse({'status': "'keyword' query param is required!"}, status=400)
    elif limit == None or limit == "":  # if limit is empty or not specified at all
        limit = 3
    elif not limit.isnumeric():  # if limit is invalid (not numeric)
        return JsonResponse({'status': "'limit' query param must be numeric if exist!"}, status=400)
    else:
        limit = int(limit)  # change limit to integer

    res = searchPaperOnCore(keyword, limit)  # call the third party api
    # if no paper found with such a keyword
    if res["status_code"] < 300 and len(res["results"]) == 0:
        return JsonResponse({'status': "There is no such content with the specified keyword on this source!"}, status=404)
    elif res["status_code"] < 300:  # if successful
        return JsonResponse(res)
    elif res["status_code"] == 429:  # if the rate limit was hit
        return JsonResponse({'status': 'The server is too busy for this request. Please try again later.'}, status=204)
    elif res["status_code"] >= 400:  # if third party returns with error
        return JsonResponse({'status': 'An internal server error has occured. Please try again later.'}, status=500)
    else:  # any other problem
        return JsonResponse({'status': 'An internal server error has occured. Please try again later.'}, status=500)
