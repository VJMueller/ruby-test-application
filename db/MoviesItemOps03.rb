# Update an Item

require "aws-sdk"

Aws.config.update({
 region: "us-west-2",
 endpoint: "http://localhost:8000"
})

dynamodb = Aws::DynamoDB::Client.new

table_name = 'Movies'
year = 2015
title = "The Big New Movie"

params = {
    table_name: table_name,
    key: {
        year: year,
        title: title
    },
    update_expression: "set info.rating = :r, info.plot=:p, info.actors=:a",
    expression_attribute_values: {
        ":r" => 5.5,
        ":p" => "Everything happens all at once.", # value
        #<Hash,Array,String,Numeric,Boolean,IO,Set,nil>
        ":a" => ["Larry", "Moe", "Curly"]
    },
    return_values: "UPDATED_NEW"
}

begin
 dynamodb.update_item(params)
 puts "Added item: #{year} - #{title}"
rescue Aws::DynamoDB::Errors::ServiceError => error
 puts "Unable to add item:"
 puts "#{error.message}"
end