[
   {
      "essential": true,
      "name":"all-users-flask-webapp",
      "image":"${REPOSITORY_URL}",
      "portMappings":[
         {
            "containerPort":5000,
            "hostPort":5000,
            "protocol":"tcp"
         }
      ],
      "environment":[]
   }
]
