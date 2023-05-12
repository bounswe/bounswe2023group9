import requests
import re
from django.http import JsonResponse, HttpRequest
import urllib.parse
import json
from . import api_keys
from . import models
from django.shortcuts import render
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout

from django.views.decorators.csrf import csrf_exempt

# GET Method for DOAJ API

def doaj_get(request):
    return doaj_api(request)

def doaj_api(request):
    DOAJ_MAX_ROW = 10
    # Parse the parameters (title and rows)
    params = request.GET
    query = params.get('title')
    rows = params.get('rows')

    # Check whether the paramters are given correctly
    # If not, return 404 JsonResponse
    if query is None or query == "":
        return JsonResponse({"status": 'Check your parameters. Example url: http://127.0.0.1:8000/api/doaj-api/?title=sun&row=3'}, status=404)
    if rows is None or rows == "" or not rows.isnumeric():
        rows = 3
    # Check whether the row exceeds the limit
    rows = int(rows) if int(rows) <= DOAJ_MAX_ROW else DOAJ_MAX_ROW

    # send GET request
    api_url = "https://doaj.org/api/search/articles/" + query + "?page=1&" + "pageSize=" + str(rows)
    res = requests.get(api_url)
    response = res.json()

    # parse the dictionary
    # all fields are assumed to exist in the response
    if res.status_code == 200:
        response_dict = {
        "status_code": 200, 
        "count": response["total"] if response["total"] < rows else rows,
        "results": [],
        }
        for index, result in enumerate(response["results"]):
            result_dict = {
                "id": result["id"],
                "source": "DOAJ",
                "position": index,
                "authors": [],
                "date": 0,
                "abstract": "NO ABSTRACT",
                "title": "NO TITLE",
                "url": "NO URL",
            }

            if "bibjson" in result.keys():
                if "author" in result["bibjson"].keys():
                    result_dict["authors"].append({'name' : author["name"] for author in result["bibjson"]["author"]}.copy())
                if "abstract" in result["bibjson"].keys():
                    result_dict["abstract"] = result["bibjson"]["abstract"]
                if "title" in result["bibjson"].keys():
                    result_dict["title"] = result["bibjson"]["title"]
                if "link" in result["bibjson"].keys() and len(result["bibjson"]["link"]) > 0 and "url" in result["bibjson"]["link"][0].keys():
                    result_dict["url"] = result["bibjson"]["link"][0]["url"]

            if "created_date" in result.keys():
                result_dict["date"] = int(result["created_date"][0:4])

            response_dict["results"].append(result_dict)
        return JsonResponse(response_dict, status=200)
    
    else:
        return JsonResponse({"status": 'Check your parameters. Example url: http://127.0.0.1:8000/api/doaj-api/?title=sun&row=3'}, status=404)


# GET api/google-scholar/
# Utilizes the serpAPI to get results from google scholar
# params -> title , rows
# response type: 200 -> {'resutls' : [{'pos' : <position> , 'source' : google_scholar, 'authors' : [ {'name' : <author-name>},{} ... ] ,
#  'date': <pub-year> , 'title' : <paper_title> , 'url' : <link-to-source> ,'abstract' : <abstract>   } ,{} ... ]}
def google_scholar(request):
    # getting the parameters
    number = request.GET.get("rows")
    search = request.GET.get("title")
    # if search title is empty return 404
    if search == None or search == "":
        return JsonResponse({'status': 'Title to search must be given.'}, status=404)
    # if rows parameter is empty / invalid use the default value = 3
    if number == None or number == "" or not number.isnumeric():
        number = 3
    else:
        number = int(number)
    # send the request to the third party api
    request = requests.get('https://serpapi.com/search.json?engine=google_scholar&q=' +
                           search + '&hl=en&num=' + str(number) + '&api_key=' + api_keys.api_keys['serp_api'])

    if request.status_code == 200: # successful request
        # get the results
        request = request.json()
        papers = request['organic_results']
        response = {}
        results = []
        for paper in papers: # iterate over the results to get necessary fields
            pub_info = paper['publication_info']
            paper_info = {}
            paper_info['source'] = 'google_scholar' # source is set

            if 'authors' in pub_info.keys(): # only take the names of the authors
                paper_info['authors'] = []
                for author in pub_info['authors']:
                    a = {'name': author['name']}
                    paper_info['authors'].append(a.copy())
            else: # if authors field is not present in the result, get them from the summary field
                temp = pub_info['summary'].split('-')[0].strip()
                temp = temp.split(',')
                authors = []
                for i in temp:
                    i = i.strip()
                    author = {}
                    author['name'] = i
                    authors.append(author.copy())
                paper_info['authors'] = authors

            paper_info['id'] = paper['result_id'] # third party id of the paper
            # this api doesn't return year / date as a field, so we get it from summary using regex
            summary = pub_info['summary']
            summary = '-' + summary + '-'
            year = re.findall('[\W|\s](\d{4})[\W|\s]', summary)
            if len(year) == 0: # if not found set 0
                year = None
                paper_info['date'] = 0000
            else:
                year = int(year[0])
                paper_info['date'] = year

            paper_info['abstract'] = paper['snippet'] # no abstract is returned from the third party so we used snippet
            paper_info['title'] = paper['title'] # title is set
            if 'link' in paper.keys():
                paper_info['url'] = paper['link'] # url is set
            paper_info['pos'] = paper['position'] # position is set
            results.append(paper_info.copy())
        response['results'] = results
        return JsonResponse(response) # results are returned
    elif request.status_code == 404: # third party returned 404
        return JsonResponse({'status': 'Unsuccessful Search.'}, status=404)
    else: # third party returned something unexpected
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
                authors.append({'name' : a['name']}.copy())

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
    title = request.GET.get("title")
    limit = request.GET.get("rows")

    if title == None or title == "":  # if no title param or empty
        return JsonResponse({'status': "'title' title param is required!"}, status=400)
    elif limit == None or limit == "":  # if limit is empty or not specified at all
        limit = 3
    elif not limit.isnumeric():  # if limit is invalid (not numeric)
        return JsonResponse({'status': "'rows' rows param must be numeric if exist!"}, status=400)
    else:
        limit = int(limit)  # change limit to integer

    res = searchPaperOnCore(title, limit)  # call the third party api
    # if no paper found with such a title
    if res["status_code"] < 300 and len(res["results"]) == 0:
        return JsonResponse({'status': "There is no such content with the specified title on this source!"}, status=404)
    elif res["status_code"] < 300:  # if successful
        return JsonResponse(res)
    elif res["status_code"] == 429:  # if the rate limit was hit
        return JsonResponse({'status': 'The server is too busy for this request. Please try again later.'}, status=204)
    elif res["status_code"] >= 400:  # if third party returns with error
        return JsonResponse({'status': 'An internal server error has occured. Please try again later.'}, status=500)
    else:  # any other problem
        return JsonResponse({'status': 'An internal server error has occured. Please try again later.'}, status=500)

def eric_papers(request):

    #params --> title, rows
    default_rows = '3'
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
    endpoint = baseURL + "?search=title:" + search_title + "&rows=" + str(rows) + response_fields

    response = requests.get(endpoint)

    if response.status_code == 200:
        papers = response.json()['response']['docs']
        i = 0
        for paper in papers:
            paper['source'] = 'eric-api'
            a = []
            if 'author' in paper.keys():
                for auth in paper['author']:
                    a.append({'name':auth}.copy())
            paper['author'] = a
            if 'publicationdateyear' in paper.keys():
                paper['date'] = paper.pop('publicationdateyear')
            else:
                paper['date'] = 0
            if 'description' in paper.keys():
                paper['abstract'] = paper.pop('description')
            else:
                paper['abstract'] = 'NO ABSTRACT'
            paper['position'] = i
            i += 1
        return JsonResponse({'results':papers})
    elif response.status_code == 404:
        return JsonResponse({'message':'Resource not found'}, status=404)
    else:
        return JsonResponse({'message':'Internal server error'}, status=503)
# GET api/zenodo
# params -> title , rows    
def zenodo(request):
    ACCESS_TOKEN = api_keys.api_keys['zenodo_api'] #Getting the third party api key from api_keys
    #Getting the parameters
    search_title = request.GET.get("title", None)
    rows = request.GET.get('rows', 3)
    if search_title is None or search_title == "" or search_title.isspace() is True: #If title is empty raise error
        return JsonResponse({'status': 'Title to search must be given.'}, status=404)
    #Third party API call
    request = requests.get('https://zenodo.org/api/records',
                     params={'q': search_title, 'sort': 'bestmatch', 'size': rows, 'access_token': ACCESS_TOKEN})

    if request.status_code == 200:  #Status code check
        papers = request.json()["hits"]["hits"] #Getting the papers
        response = {}
        results = []
        for paper in papers: #For every paper, get the wanted attributes
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
                paper_info['authors'].append({'name':author['name']}) 
            results.append(paper_info.copy()) #Add the paper attributes into results
        response['results'] = results 
        return JsonResponse(response, status=200) #Return results as response
    elif request.status_code == 404:
        return JsonResponse({'status': 'Unsuccessful Search.'}, status=404)
    else:
        return JsonResponse({'status': 'An internal server error has occured. Please try again.'}, status=503)

def semantic_scholar(request):
    query = request.GET
    search = query.get("title")
    limit = query.get("rows")
    default_limit = 3
    if search is None or search == "":
        return JsonResponse({'status': 'Title to search must be given.'}, status=404)
    if limit is None or limit == "" or not limit.isnumeric():
        limit = default_limit
    else:
        limit = int(limit)


    fields = ['url','abstract','authors','title','year']
    endpoint = f'https://api.semanticscholar.org/graph/v1/paper/search?query={search}&fields={",".join(fields)}&offset=0&limit={limit}'

    response = requests.get(endpoint)
    if response.status_code == 200:
        response = response.json()
        papers = response['data']
        response = {}
        results = []
        for position,paper in enumerate(papers):
            paper_info = {}
            paper_info['source'] = 'semantic_scholar'
            paper_info['authors'] = []
            for author in paper['authors']:
                author_name = {'name' : author['name']}
                paper_info['authors'].append(author_name.copy())
            paper_info['id'] = paper['paperId']
            paper_info['abstract'] = paper['abstract']
            paper_info['title'] = paper['title']
            paper_info['url'] = paper['url']
            paper_info['date'] = paper['year']
            paper_info['position'] = position
            results.append(paper_info.copy())
        response['results'] = results
        return JsonResponse(response)
    
# GET Method for NASA STI OpenAPI
# params -> title, rows
# title: required, title of the paper to be searched
# rows: not required, number of papers to be returned, if not provided or nonnumeric value provided then default value is 3
# response type: {"results": [{"title": string, "url": string, "authors": [string], "abstract": string, "date": int, "position": int, "source": string}]}
def nasa_sti(request):
    query = request.GET.get("title", None)
    paper_number = request.GET.get('rows')
    default_paper_number = 3

    if query is None or query == "":
        return JsonResponse({'status': 'Title to search must be given.'}, status=400)
    
    if paper_number is None or default_paper_number == "" or not paper_number.isnumeric():
        paper_number = default_paper_number
    
    request = requests.get('https://ntrs.nasa.gov/api/citations/search', params={'abstract': query, 'page.size': paper_number})

    if request.status_code == 200:
        papers = request.json()["results"]
        response = {}
        results = []
        for paper in papers:
            paper_info = {}
            paper_info['id'] = paper['id']
            paper_info['title'] = paper['title']
            if len(paper['downloads']) > 0:
                paper_info['url'] = "https://ntrs.nasa.gov" + paper['downloads'][0]['links']['original']
            else:
                paper_info['url'] = '/'
            paper_info['authors'] = []
            if 'authorAffiliations' in paper:
                authors = paper['authorAffiliations']
                for author in authors:
                    paper_info['authors'].append({'name' : author['meta']['author']['name']}.copy())
            paper_info['abstract'] = paper['abstract']
            paper_info['date'] = int(paper['created'].split("-")[0])
            paper_info['position'] = papers.index(paper)
            paper_info['source'] = 'Nasa STI'
            results.append(paper_info.copy())
        response['results'] = results
        return JsonResponse(response, status=200)
    elif request.status_code == 404:
        return JsonResponse({'status': 'Unsuccessful Search.'}, status=404)
    else:
        return JsonResponse({'status': 'An internal server error has occured. Please try again.'}, status=503)

# GET api/orcid_api/
# Utilizes the orcid api to get user credentials
# params -> user_id
# response type: {"user_id": string, "name": string, "surname": string}
def orcid_api(request):
    # user_id should be a valid ORCID ID
    user_id = request.GET.get('user_id')

    Headers = {"Accept": "application/json"}

    if user_id == None or user_id == '':
        return JsonResponse({"status":"ORCID ID should be provided as user_id"}, status = 404)
    # third party api call
    # returns a json file that contains all public information related with given ORCID ID
    api_request = requests.get("https://orcid.org/"+user_id, headers=Headers)

    if api_request.status_code != 200:
        return JsonResponse({"status":"Invalid ORCID ID"}, status = 404)
    else:
        try:
            api_request = api_request.json()
        except:
            return JsonResponse({"status":"Invalid ORCID ID"}, status = 404)
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
@csrf_exempt
def log_in(request):
    if 'username' not in request.headers or 'password' not in request.headers:
        return JsonResponse({'status' : 'username and password fields can not be empty '},status=407)

    username = request.headers["username"]
    password = request.headers["password"]

    if username == None or username == '':
        return JsonResponse({"status":"ORCID ID should be provided."}, status = 404)

    if password == None or password == '':
        return JsonResponse({"status":"Password should be provided."}, status = 404)

    # Check user database to authenticate the user with given credentials. Return a user if valid username and password is given.
    user = authenticate(request, username=username, password=password)

    # if the user is authenticated log in by built-in login function
    if user is not None:
        login(request, user)
        return JsonResponse({"status":"User logged in."}, status = 200)

    else:
        return JsonResponse({"status":"Authentication failed"}, status = 404)

# GET api/log_out/
# get user to log out by built-in logout function
@csrf_exempt
def log_out(request):
    logout(request)
    return JsonResponse({"status":"User logged out."}, status = 200)

# POST api/user_registration
# username and password should be in headers
# username should be unique
# name and surname should be provided in data
# username, name, password must be provided, surname is optional

@csrf_exempt
def user_registration(request):
    if 'username' not in request.headers or 'password' not in request.headers:
        return JsonResponse({'status' : 'username and password fields can not be empty '},status=407)
    user_id = request.headers["username"]
    password = request.headers['password']

    # create a GET request to call orcid_api()
    orcid_api_request = HttpRequest()
    orcid_api_request.method = 'GET'
    orcid_api_request.user = request.user
    orcid_api_request.META = request.META
    orcid_api_request.session = request.session
    orcid_api_request.GET.update({"user_id": user_id})
    orcid_api_response = orcid_api(orcid_api_request)

    if orcid_api_response.status_code == 200:
        name = json.loads(orcid_api_response.content.decode()).get("name")
        surname = json.loads(orcid_api_response.content.decode()).get("surname")
    else:
        return JsonResponse({"status":"Valid ORCID ID should be provided."}, status = 404)

    if user_id == None or user_id == '':
        return JsonResponse({"status":"ORCID ID should be provided."}, status = 404)

    if password == None or password == '':
        return JsonResponse({"status":"Password should be provided."}, status = 404)

    if name == None or name == '':
        return JsonResponse({"status":"Name should be provided."}, status = 404)

    if surname == None:
        surname = " "

    # Check if the user_id is already taken.
    if len(User.objects.filter(username= user_id)) == 0:
        # Create user on User model by using create_user function.
        # Used create_user() instead of create() since create_user() handles password encryption
        User.objects.create_user(username= user_id, password= password, first_name= name,last_name= surname )
        return JsonResponse({"status":"User created"}, status = 200)

    else:
        return JsonResponse({"status":"Username is already taken."}, status = 409)

# POST Method to create paper list
@csrf_exempt
def create_paper_list(request):
    user = request.user

    if user.is_anonymous:
        # If user is anonymous and credentials are not provided in headers return an error
        if 'username' not in request.headers or 'password' not in request.headers:
            return JsonResponse({'status': 'Username and password must be supplied!'}, status=407)

        # If there are credential information in headers authenticate the user
        username = request.headers['username']
        password = request.headers['password']

        user = authenticate(request, username=username, password=password)
        if user == None:
            # If the authentication is failed return an error
            return JsonResponse({'status' : 'Incorrect username or password!'}, status=401)
    
    # Get the paper name with the POST method
    try:
        list_title = request.POST['list_title']
    except KeyError:
        return JsonResponse({'status': 'Paper list title must be provided!'}, status=400)

    paper_list = models.PaperList.objects.create(list_title=list_title, owner=user) # create instance
    paper_list.save() # Insert to the database 

    # Return a success response
    return JsonResponse({'status': 'Paper list created successfully!'}, status=200)


@csrf_exempt
def save_paper_list(request):

    user = request.user

    if user.is_anonymous:
        # If user us anonymous and credentials are not provided in headers return an error
        if 'username' not in request.headers or 'password' not in request.headers:
            return JsonResponse({'status': 'Empty username or password!'}, status=407)
        # If there are credential information in headers authenticate the user
        username = request.headers['username']
        password = request.headers['password']
        user = authenticate(request, username=username, password=password)
        if user == None:
            # If the authentication is failed return an error
            return JsonResponse({'status' : 'Incorrect username or password!'},status=401)

    # Get the paper list id with the POST method
    try:
        post_id = request.POST['paper_list_id']
    except KeyError:
        return JsonResponse({'status': 'Paper list id must be provided!'}, status=404)
    
    #Check if the provided id is valid
    if not post_id.isnumeric() or post_id == None or not models.PaperList.objects.filter(id = post_id).exists():
        return JsonResponse({'status': 'Paper list is not found!'}, status=404)
    else:
        # Get the paper list object and add the current logged in user to the savers list of the paper list
        paper_list = models.PaperList.objects.get(pk = post_id)
        paper_list.saver.add(user)

        # Save the changes
        paper_list.save()

        # Return a success response
        return JsonResponse({'status': 'Paper list is saved successfully!'}, status=200)
    
# POST api/follow/
# username and password of follower should be in headers
# username of followed should be in data

@csrf_exempt
def follow_user(request):
    if request.user.is_anonymous:
        if 'username' not in request.headers or 'password' not in request.headers:
            return JsonResponse({'status': 'username and password fields can not be empty'}, status=407)
        username = request.headers['username']
        password = request.headers['password']
        follower_user = authenticate(request, username=username, password=password)
        if follower_user == None:
            return JsonResponse({'status' : 'user credentials are incorrect.'},status=401)
    else:
        follower_user = request.user

    query = request.POST
    followed_username = query.get('followed_username')
    if followed_username == None or followed_username == '':
        return JsonResponse({"status":"Username of followed should be provided."}, status = 400)

    if User.objects.filter(username=followed_username).exists():
        followed_user = User.objects.get(username=followed_username)
        if models.Follower.objects.filter(user=follower_user, followed=followed_user).exists() and models.Follower.objects.filter(user=followed_user, follower=follower_user).exists():
            return JsonResponse({"status":"You are already following this user."}, status=409)
        elif models.FollowRequest.objects.filter(sender=follower_user, receiver=followed_user).exists():
            return JsonResponse({"status":"You have already sent a following request this user."}, status=409)
        else:
            models.FollowRequest.objects.create(sender=follower_user, receiver=followed_user, status='pending')
            return JsonResponse({"status":"User followed."}, status = 200)
    else:
        return JsonResponse({"status":"Username of followed is invalid."}, status = 404)

@csrf_exempt
def post_papers(request):
    # Authentication
    if request.user.is_anonymous: # user is not logged in
        if 'username' not in request.headers or 'password' not in request.headers: # credentials are incomplete
            return JsonResponse({'status': 'username and password fields can not be empty'}, status=407)
        username = request.headers['username']
        password = request.headers['password']
        user = authenticate(request, username=username, password=password)
        if user == None: # credentials are incorrect
            return JsonResponse({'status' : 'user credentials are incorrect.'},status=401)
    else:
        user = request.user

    query = request.POST
    if 'db' not in query.keys() or 'title' not in query.keys(): # db parameter or title parameter is not set
        return JsonResponse({'status' : 'db and title parameters must be added to the request body.'},status=400)
    db = query.get('db')
    title = query.get('title')
    if 'rows' not in query.keys(): # default rows value if it is not set
        rows = 3
    else:
        rows = query.get('rows')

    api_request = HttpRequest() # creating a GET request to pass to the API methods
    api_request.method = 'GET'
    api_request.user = user
    api_request.META = request.META
    api_request.GET.update({"title": title,'rows':rows})

    if db == None or db == "": # db parameter is empty
        return JsonResponse({'status': 'Database to search must be specified. Please select one : semantic-scholar , doaj , core , zenodo , eric , google-scholar'}, status=404)
    # calling the API method for the given db parameter
    if db == 'semantic-scholar':
        response = semantic_scholar(api_request)
    elif db == 'doaj':
        response = doaj_api(api_request)
    elif db == 'core':
        response = core_get(api_request)
    elif db == 'zenodo':
        response = zenodo(api_request)
    elif db == 'eric':
        response = eric_papers(api_request)
    elif db == 'google-scholar':
        response = google_scholar(api_request)
    elif db == 'nasa-sti':
        response = nasa_sti(api_request)
    else: # db parameter doesn't match with any of the options available
        return JsonResponse({'status': 'Invalid database name. Please select one of the following : semantic-scholar , doaj , core , zenodo , eric , google-scholar'}, status=404)
    if response.status_code != 200: # the call is not successful / something unexpected happened
        return response
    results = json.loads(response.content)['results'] # loading the json response
    for result in results: # iterating over the response to save the results to the database
        if models.Paper.objects.filter(source=result['source'],third_party_id=result['id'] ).exists(): # if the paper exists in the database, pass
            continue
        paper = models.Paper() # create Paper object
        # Fill the fields
        if 'url' in result.keys():
            paper.url = result['url']
        paper.title = result['title']
        if 'authors' in result.keys():
            paper.set_authors(result['authors'])
        if 'date' in result.keys():
            paper.year = result['date']
        paper.third_party_id = result['id']
        paper.source = result['source']
        if 'abstract' in result.keys():
            paper.abstract = result['abstract']
        paper.like_count = 0
        paper.save() # save to the DB
    return JsonResponse({'status': 'Requested papers are saved successfully.'}, status=200) # success response

@csrf_exempt
def add_interest(request):
    # Authentication
    if request.user.is_anonymous:  # The user is not logged in
        if 'username' not in request.headers or 'password' not in request.headers:  # Check the credentials and return error accordingly
            return JsonResponse({'status': 'Username and password fields can not be empty'}, status=407)
        username = request.headers['username']  # Get the credentials from header
        password = request.headers['password']
        current_user = authenticate(request, username=username, password=password)
        if current_user == None:  # If the authentication is failed return an error
            return JsonResponse({'status': 'User credentials are incorrect.'}, status=401)
    else:
        current_user = request.user
    query = request.POST
    added_interest = query.get('interest')  # Get the interest to be added from query
    # If interest is empty or None, raise error
    if added_interest is None or added_interest == '':
        return JsonResponse({'status': 'Name of the interest can\'t be empty.'}, status=400)

    try:  # If there interest has been added before, raise error.
        select = models.UserInterest.objects.get(user_id=current_user.id, interest=added_interest)
        return JsonResponse({'status': 'This interest has already been added'}, status=407)

    except models.UserInterest.DoesNotExist:  # Else add the interest to user.
        interest_list = models.UserInterest(user_id=current_user.id, interest=added_interest)
        interest_list.save()
    return JsonResponse({'status': 'Interest has been added to profile successfully!'}, status=200)

@csrf_exempt
def add_paper_to_list(request):
    if request.user.is_anonymous:
        if 'username' not in request.headers or 'password' not in request.headers:
            return JsonResponse({'status': 'username and password fields can not be empty '}, status=407)
        username = request.headers['username']
        password = request.headers['password']
        user = authenticate(request, username=username, password=password)
        if user == None:
            return JsonResponse({'status' : 'user credentials are incorrect.'},status=401)
    
    data = request.POST
    list_id = data.get("list_id")
    pid = data.get("paper_id")
    
    if not list_id.isnumeric() or not pid.isnumeric():
        return JsonResponse({"status":"Either list id or paper id is missing, or they are not integer"}, status = 400)

    paper_lists = models.PaperList.objects.filter(id=list_id)
    if len(paper_lists) == 0:
        return JsonResponse({"status":"No Such List"}, status = 400)
    elif len(paper_lists) > 1:
        return JsonResponse({"status":"More than 1 List Found"}, status = 400)
    
    papers = models.Paper.objects.filter(paper_id=pid)
    if len(papers) == 0:
        return JsonResponse({"status":"No Such Paper"}, status = 400)
    elif len(papers) > 1:
        return JsonResponse({"status":"More than 1 Paper Found"}, status = 400)

    paper_lists[0].paper.add(papers[0])
    return JsonResponse({"status":"Paper Has Been Added To The List"}, status = 200)

def accept_follow_request(request):

    if request.user.is_anonymous:
        if 'username' not in request.headers or 'password' not in request.headers:
            return JsonResponse({'status': 'username and password fields can not be empty'}, status=407)
        username = request.headers['username']
        password = request.headers['password']
        follower_user = authenticate(request, username=username, password=password)
        if follower_user == None:
            return JsonResponse({'status': 'user credentials are incorrect.'}, status=401)

    query = request.POST
    sender_id = query.get('sender_id')
    receiver_id = query.get('receiver_id')

    if not User.objects.filter(username=sender_id).exists():
        return JsonResponse({"status": "User/users not found"}, status=400)

    if not User.objects.filter(username=receiver_id).exists():
        return JsonResponse({"status": "User/users not found"}, status=400)

    sender = User.objects.get(username=sender_id)
    receiver = User.objects.get(username=receiver_id)

    if models.FollowRequest.objects.filter(sender=sender, receiver=receiver).exists():
        if models.FollowRequest.objects.filter(sender=sender, receiver=receiver, status='pending').exists():
            if not models.Follower.objects.filter(user=receiver).exists():
                models.Follower.objects.create(user=receiver)
            receiver_follower = models.Follower.objects.get(user=receiver)
            if not models.Follower.objects.filter(user=sender).exists():
                models.Follower.objects.create(user=sender)
            receiver_follower.follower.add(sender)
            sender_follower = models.Follower.objects.get(user=sender)
            sender_follower.followed.add(receiver)
            follow_request = models.FollowRequest.objects.filter(sender=sender, receiver=receiver, status='pending')[0]
            follow_request.status = 'accepted'
            follow_request.save()
            return JsonResponse({"status": "Follow request accepted"}, status=200)
        else:
            return JsonResponse({"status": "Follow request is already answered"}, status=400)
    else:
        return JsonResponse({"status": "There is no such follow request"}, status=400)

def reject_follow_request(request):
    if request.user.is_anonymous:
        if 'username' not in request.headers or 'password' not in request.headers:
            return JsonResponse({'status': 'username and password fields can not be empty'}, status=407)
        username = request.headers['username']
        password = request.headers['password']
        follower_user = authenticate(request, username=username, password=password)
        if follower_user == None:
            return JsonResponse({'status': 'user credentials are incorrect.'}, status=401)

    query = request.POST
    sender_id = query.get('sender_id')
    receiver_id = query.get('receiver_id')

    if not User.objects.filter(username=sender_id).exists():
        return JsonResponse({"status": "User/users not found"}, status=400)

    if not User.objects.filter(username=receiver_id).exists():
        return JsonResponse({"status": "User/users not found"}, status=400)

    sender = User.objects.get(username=sender_id)
    receiver = User.objects.get(username=receiver_id)

    if models.FollowRequest.objects.filter(sender=sender, receiver=receiver).exists():
        if models.FollowRequest.objects.filter(sender=sender, receiver=receiver, status='pending').exists():
            follow_request = models.FollowRequest.objects.filter(sender=sender, receiver=receiver, status='pending')[0]
            follow_request.status = 'rejected'
            follow_request.save()
            return JsonResponse({"status": "Follow request rejected"}, status=200)
        else:
            return JsonResponse({"status": "Follow request is already answered"}, status=400)
    else:
        return JsonResponse({"status": "There is no such follow request"}, status=400)



# POST api/like-paper/
@csrf_exempt
def like_paper(request):
    if request.user.is_anonymous:
        if 'username' not in request.headers or 'password' not in request.headers:
            return JsonResponse({'status': 'Username and password fields can not be empty'}, status=407)
        username = request.headers['username']
        password = request.headers['password']
        current_user = authenticate(request, username=username, password=password)
        if current_user == None:
            return JsonResponse({'status' : 'User credentials are incorrect.'},status=401)
    else:
        current_user = request.user

    query = request.POST
    liked_paper = query.get('paper_id')
    if liked_paper == None or liked_paper == '':
        return JsonResponse({"status":"Paper should be provided."}, status = 400)

    if models.Paper.objects.filter(paper_id=liked_paper).exists():
        paper = models.Paper.objects.get(paper_id=liked_paper)
        if models.Like.objects.filter(user=current_user, paper=paper).exists():
            return JsonResponse({"status":"You are already liked this paper."}, status=409)
        else:
            models.Like.objects.create(user=current_user, paper=paper)
            paper.like_count +=1
            paper.save()
            return JsonResponse({"status":"Paper liked."}, status = 200)
    else:
        return JsonResponse({"status":"Paper id is invalid."}, status = 404)
    
#returns the followers of the user
def get_followers(request):
    user = request.user
    follow_object = models.Follower.objects.filter(user=user)
    response = []
    if len(follow_object) == 0:
        return JsonResponse({'followers': response}, status=200)
    for _user in  follow_object[0].follower.all():
        res = {}
        res['user_id'] = _user.username
        res['name'] = _user.first_name
        res['surname'] = _user.last_name
        response.append(res.copy())
    return  JsonResponse({'followers' : response} , status=200)


#returns the following of the user
def get_following(request):
    user = request.user
    follow_object = models.Follower.objects.filter(user=user)
    response = []
    if len(follow_object) == 0:
        return JsonResponse({'following': response}, status=200)
    for _user in follow_object[0].followed.all():
        res = {}
        res['user_id'] = _user.username
        res['name'] = _user.first_name
        res['surname'] = _user.last_name
        response.append(res.copy())
    return JsonResponse({'following': response}, status=200)
