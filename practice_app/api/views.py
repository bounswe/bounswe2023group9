import requests
import re
from django.http import JsonResponse
from . import api_keys
from django.shortcuts import render
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout


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
    api_url = "https://doaj.org/api/search/articles/" + \
        query + "?page=1&" + "pageSize=" + str(rows)
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


def eric_papers(request):

    # params --> title, rows
    default_rows = '5'

    search_title = request.GET.get('title')
    rows = request.GET.get('rows', default_rows)

    if search_title == None or search_title.strip() == '':
        return JsonResponse({'message': 'A paper title must be given.'}, status=404)

    try:
        int(rows)
    except ValueError:
        return JsonResponse({'message': 'Row count must be valid.'}, status=404)

    # response --> source, authors, id, date, abstract, title, url, position

    baseURL = "https://api.ies.ed.gov/eric/"
    response_fields = "&fields=id AND title AND author AND publicationdateyear AND url AND description AND source"
    endpoint = baseURL + "?search=title:" + \
        search_title + "&rows=" + rows + response_fields

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

        return JsonResponse({'papers': papers})
    elif response.status_code == 404:
        return JsonResponse({'message': 'Resource not found'}, status=404)
    else:
        return JsonResponse({'message': 'Internal server error'}, status=503)

# GET api/orcid_api/
# Utilizes the orcid api to get user credentials
# params -> user_id
# response type: {"user_id": string, "name": string, "surname": string}


def orcid_api(request):

    # user_id should be a valid ORCID ID
    user_id = request.GET.get('user_id')

    Headers = {"Accept": "application/json"}

    if user_id == None or user_id == '':
        return JsonResponse({"status": "ORCID ID should be provided as user_id"}, status=404)

    # third party api call
    # returns a json file that contains all public information related with given ORCID ID
    api_request = requests.get("https://orcid.org/"+user_id, headers=Headers)

    if api_request.status_code != 200:
        return JsonResponse({"status": "Invalid ORCID ID"}, status=404)
    else:
        try:
            api_request = api_request.json()
        except:
            return JsonResponse({"status": "Invalid ORCID ID"}, status=404)

        response = {}
        response["user_id"] = user_id
        response["name"] = api_request["person"]["name"]["given-names"]["value"]

        if api_request["person"]["name"]["family-name"] != None:
            response["surname"] = api_request["person"]["name"]["family-name"]["value"]
        else:
            response["surname"] = " "
        return JsonResponse(response)

# POST api/log_in/
# implements log in functionality
# username and password should be provided in Headers


def log_in(request):

    username = request.headers["username"]
    password = request.headers["password"]

    if username == None or username == '':
        return JsonResponse({"status": "ORCID ID should be provided."}, status=404)

    if password == None or password == '':
        return JsonResponse({"status": "Password should be provided."}, status=404)

    # Check user database to authenticate the user with given credentials. Return a user if valid username and password is given.
    user = authenticate(request, username=username, password=password)

    # if the user is authenticated log in by built-in login function
    if user is not None:
        login(request, user)
        return JsonResponse({"status": "User logged in."}, status=200)

    else:
        return JsonResponse({"status": "Authentication failed"}, status=404)

# GET api/log_out/
# get user to log out by built-in logout function


def log_out(request):
    logout(request)
    return JsonResponse({"status": "User logged out."}, status=200)

# POST api/user_registration
# username and password should be in headers
# username should be unique
# name and surname should be provided in data
# username, name, password must be provided, surname is optional


def user_registration(request):

    user_id = request.headers["username"]
    password = request.headers['password']

    url = "http://127.0.0.1:8000/api/orcid_api/?user_id=" + user_id
    orcid_api_response = requests.get(url=url)

    if orcid_api_response.status_code == 200:
        orcid_api_response = orcid_api_response.json()
        name = orcid_api_response['name']
        surname = orcid_api_response['surname']
    else:
        return JsonResponse({"status": "Valid ORCID ID should be provided."}, status=404)

    if user_id == None or user_id == '':
        return JsonResponse({"status": "ORCID ID should be provided."}, status=404)

    if password == None or password == '':
        return JsonResponse({"status": "Password should be provided."}, status=404)

    if name == None or name == '':
        return JsonResponse({"status": "Name should be provided."}, status=404)

    if surname == None:
        surname = " "

    # Check if the user_id is already taken.
    if len(User.objects.filter(username=user_id)) == 0:
        # Create user on User model by using create_user function.
        # Used create_user() instead of create() since create_user() handles password encryption
        User.objects.create_user(
            username=user_id, password=password, first_name=name, last_name=surname)
        return JsonResponse({"status": "User created"}, status=200)

    else:
        return JsonResponse({"status": "Username is already taken."}, status=404)
