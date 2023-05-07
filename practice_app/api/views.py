from django.shortcuts import render
from django.http import JsonResponse
import requests


def doaj_get(request):
    DOAJ_MAX_ROW = 10
    
    # Parse the parameters (query and row)
    # Check whether the paramters are given correctly
    try:
        params = request.get_full_path().split('?')[-1].split('&')
        keys = [param.split('=')[0] for param in params]
        if keys[0] != 'query' or keys[1] != 'row':
            raise Exception
        args = [param.split('=')[-1] for param in params]
        query = args[0]
        row = int(args[1]) if int(args[1]) <= DOAJ_MAX_ROW else DOAJ_MAX_ROW
    except:
        return JsonResponse({"status": 'Check your parameters. Example url: http://127.0.0.1:8000/api/doaj-api/?query=sun&row=3'}, status=404)

    # send GET request
    api_url = "https://doaj.org/api/search/articles/" + query + "?page=1&" + "pageSize=" + str(row)
    res = requests.get(api_url)
    response = res.json()

    # parse the dictionary
    # all fields are assumed to exist in the response
    if res.status_code == 200:
        return JsonResponse(
            {
                "status_code": 200,
                "count": response["total"] if response["total"] < row else row,
                "results": [
                    {
                        "id": result["id"],
                        "source": "DOAJ",
                        "authors": [author["name"] for author in result["bibjson"]["author"]],
                        "date": result["created_date"],
                        "abstract": result["bibjson"]["abstract"],
                        "title": result["bibjson"]["title"],
                        "url": result["bibjson"]["link"][0]["url"]
                    } for result in response["results"]
                ]
            }
        )
    else:
        return JsonResponse({"status": 'Check your parameters. Example url: http://127.0.0.1:8000/api/doaj-api/?query=sun&row=3'}, status=404)


    
