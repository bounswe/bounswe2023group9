import requests
import re
from django.http import JsonResponse
from . import api_keys
from django.shortcuts import render

# Create your views here.

def google_scholar(request):
    number = request.GET.get("rows")
    search = request.GET.get("title")
    if search == None or search == "":
        return JsonResponse({'status': 'Title to search must be given.'}, status=404)
    if number == None or number == "" or not number.isnumeric():
        number = 5
    else:
        number = int(number)

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


def eric_papers(request):
    
    #params --> title, rows
    default_rows = '5'

    search_title = request.GET.get('title')
    rows = request.GET.get('rows', default_rows)

    if search_title == None or search_title.strip() == '':
        return JsonResponse({'message':'A paper title must be given.'}, status=404)
   
    try:
        int(rows)
    except ValueError:
        return JsonResponse({'message':'Row count must be valid.'}, status=404)

    #response --> source, authors, id, date, abstract, title, url, position

    baseURL = "https://api.ies.ed.gov/eric/"
    response_fields = "&fields=id AND title AND author AND publicationdateyear AND url AND description AND source"
    endpoint = baseURL + "?search=title:" + search_title + "&rows=" + rows + response_fields

    response = requests.get(endpoint)

    if response.status_code == 200:
        papers = response.json()['response']['docs']
        
        i = 0
        for paper in papers:
            paper['source'] = 'eric-api'
            paper['date'] = paper.pop('publicationdateyear')
            paper['abstract'] = paper.pop('description')
            paper['position'] = i
            i += 1
            
        return JsonResponse({'papers':papers})
    elif response.status_code == 404:
        return JsonResponse({'message':'Resource not found'}, status=404)
    else:
        return JsonResponse({'message':'Internal server error'}, status=503)
def zenodo(request):
    ACCESS_TOKEN = api_keys.api_keys['zenodo_api']
    search_title = request.GET.get("search_title", None)
    rows = request.GET.get('rows', 5)
    if search_title is None or search_title == "" or search_title.isspace() is True:
        return JsonResponse({'status': 'Title to search must be given.'}, status=404)

    request = requests.get('https://zenodo.org/api/records',
                     params={'q': search_title, 'sort': 'bestmatch', 'size': rows, 'access_token': ACCESS_TOKEN})

    if request.status_code == 200:
        papers = request.json()["hits"]["hits"]
        response = {}
        results = []
        for paper in papers:
            paper_info = {}
            paper_info['id'] = paper['id']
            paper_info['title'] = paper['metadata']['title']
            paper_info['url'] = paper['links']['doi']
            paper_info['authors'] = []
            paper_info['abstract'] = paper['metadata']['description']
            paper_info['date'] = int(paper['metadata']['publication_date'].split("-")[0])
            paper_info['position'] = papers.index(paper)
            paper_info['source'] = 'Zenodo'
            authors = paper['metadata']['creators']
            for author in authors:
                paper_info['authors'].append(author['name'])
            results.append(paper_info.copy())
        response['results'] = results
        return JsonResponse(response, status=200)
    elif request.status_code == 404:
        return JsonResponse({'status': 'Unsuccessful Search.'}, status=404)
    else:
        return JsonResponse({'status': 'An internal server error has occured. Please try again.'}, status=503)

