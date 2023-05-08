from django.shortcuts import render
from django.http import JsonResponse
import requests


def doaj_get(request):
    DOAJ_MAX_ROW = 10
    
    # Parse the parameters (query and rows)
    params = request.GET
    query = params.get('query')
    rows = params.get('rows')

    # Check whether the paramters are given correctly
    # If not, return 404 JsonResponse
    if query is None or query == "" or rows is None or rows == "" or not rows.isnumeric():
        return JsonResponse({"status": 'Check your parameters. Example url: http://127.0.0.1:8000/api/doaj-api/?query=sun&row=3'}, status=404)
    
    # Check whether the row exceeds the limit
    rows = int(rows) if int(rows) <= DOAJ_MAX_ROW else DOAJ_MAX_ROW

    # send GET request
    api_url = "https://doaj.org/api/search/articles/" + query + "?page=1&" + "pageSize=" + str(rows)
    res = requests.get(api_url)
    response = res.json()

    # parse the dictionary
    # all fields are assumed to exist in the response
    if res.status_code == 200:
        return JsonResponse(
            {
                "status_code": 200,
                "count": response["total"] if response["total"] < rows else rows,
                "results": [
                    {
                        "id": result["id"],
                        "source": "DOAJ",
                        "position": index + 1,
                        "authors": [author["name"] for author in result["bibjson"]["author"]],
                        "date": result["created_date"],
                        "abstract": result["bibjson"]["abstract"],
                        "title": result["bibjson"]["title"],
                        "url": result["bibjson"]["link"][0]["url"]
                    } for index, result in enumerate(response["results"])
                ]
            }
        )
    else:
        return JsonResponse({"status": 'Check your parameters. Example url: http://127.0.0.1:8000/api/doaj-api/?query=sun&row=3'}, status=404)


    
