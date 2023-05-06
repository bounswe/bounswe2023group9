from django.shortcuts import render
import requests
# Create your views here.

from django.http import JsonResponse, HttpResponse

def eric_index(request):
    return HttpResponse("Welcome to ERIC API!")

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

    

