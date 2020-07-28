#Query - All Movies Released in a Year

require "aws-sdk"

Aws.config.update({
 region: "us-west-2",
 endpoint: "http://localhost:8000"
})

dynamodb = Aws::DynamoDB::Client.new

table_name = "Movies"

params = {
    table_name: table_name,
    key_condition_expression: "#yr = :yyyy",
    expression_attribute_names: {
        "#yr" => "year"
    },
    expression_attribute_values: {
        ":yyyy" => 1985
    }
}

puts "Querying for movies from 1985.";

begin
    result = dynamodb.query(params)
    puts "Query succeeded."
    result.items.each{|movie|
        puts "#{movie["year"].to_i} #{movie["title"]}"
    }
rescue Aws::DynamoDB::Errors::ServiceError => error
    puts "Unable to query table:"
    puts "#{error.message}"
end