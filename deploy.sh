docker build \
  -t jcartwright/daily_dad_jokes:latest \
  -t jcartwright/daily_dad_jokes:$SHA .

docker push jcartwright/daily_dad_jokes:latest
docker push jcartwright/daily_dad_jokes:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment \
  server=jcartwright/daily_dad_jokes:$SHA
