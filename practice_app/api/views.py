import requests
import re
from django.http import JsonResponse
from . import api_keys


def serp_api(request):
    url = request.get_full_path().split('?')[-1] + '&'
    search, number = None, None
    if url.find("title") == -1:
        return JsonResponse({'status': 'Title to search must be given.'}, status=404)
    if url.find('rows') == -1:
        number = 5
        search = re.findall('title=(.*?)&',url)[0]
    else:
        search = re.findall('title=(.*?)&', url)[0]
        number = int(re.findall('rows=(.*?)&', url)[0])
    if search == "":
        return JsonResponse({'status': 'Title to search must be given.'}, status=404)
    if search == None or number == None:
        return JsonResponse({'status': 'Please check your parameters.'}, status=404)

    request = requests.get('https://serpapi.com/search.json?engine=google_scholar&q=' + search + '&hl=en&num=' + str(number) + '&api_key=' + api_keys.api_keys['serp_api'])
    if request.status_code == 200:
        request = request.json()
        papers = request['organic_results']
        response = {}
        results = []
        for paper in papers:
            pub_info = paper['publication_info']
            paper_info = {}
            paper_info['source'] = 'google_scholar'

            if 'authors' in  pub_info.keys():
                paper_info['authors'] = []
                for author in pub_info['authors']:
                    a = {'name' : author['name']}
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
        return JsonResponse({'status': 'An internal server error has occured. Please try again.'},status=503)