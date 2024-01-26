#!/bin/bash

while getopts ":S:p:t:e:r:s:" opt; do

  case $opt in

    S) 
    
    S3_BUCKET_NAME="$OPTARG"

      ;;
    p) 
    
    tfpath="$OPTARG"

      ;;

     t)

      tenentname="$OPTARG"

      ;;

    e)

      env="$OPTARG"

      ;;

    r)

      resourse="$OPTARG"

      ;;

    s)

      status="$OPTARG"

      ;;

    \?)

      echo "Invalid option: -$OPTARG" >&2

      exit 1

      ;;

    :)

      echo "Option -$OPTARG requires an argument." >&2

      exit 1

      ;;

  esac

done

echo "status= $status"

if [ "$status" == "new" ]

    then


wordcount=$(aws s3 ls s3://${S3_BUCKET_NAME}/${tenentname}/${resourse}/${env}/ | grep terraform.tfstate | wc -c)
   
   echo "wordcount= $wordcount"

   if [ "$wordcount" -eq 0 ]; then

    echo "---------- uploading new terraform.tfstate for ${tenentname}/${resourse}/${env} ---------"
   
   aws s3api put-object --bucket "${S3_BUCKET_NAME}" --key "${tenentname}/${resourse}/${env}" 

   aws s3 cp "$tfpath/terraform.tfstate" "s3://${S3_BUCKET_NAME}/${tenentname}/${resourse}/${env}/terraform.tfstate"
   echo "---------- upload completed ------ new terraform.tfstate for ${tenentname}/${resourse}/${env} ---------"

   else

   {
   echo "---------- uploading updated terraform.tfstate for ${tenentname}/${resourse}/${env} ---------"
   aws s3 cp "$tfpath/terraform.tfstate" "s3://${S3_BUCKET_NAME}/${tenentname}/${resourse}/${env}/terraform.tfstate" 
   echo "---------- uploaded updated terraform.tfstate for ${tenentname}/${resourse}/${env} ---------"
   }

   fi

else

    aws s3 cp "s3://${S3_BUCKET_NAME}/${tenentname}/${resourse}/${env}/terraform.tfstate" "$tfpath/terraform.tfstate"

fi

