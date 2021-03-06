# Update an Item (Conditionally)

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
    update_expression: "remove info.actors[0]",
    condition_expression: "size(info.actors) >= :num",
    expression_attribute_values: {
        ":num" => 3
    },
    return_values: "UPDATED_NEW"
}

begin
    result = dynamodb.update_item(params)
    puts "Updated item. ReturnValues are:"
    result.attributes["info"].each do |key, value|
        if key == "rating"  
            puts "#{key}: #{value.to_f}"
        else
            puts "#{key}: #{value}"
        end
    end
    rescue Aws::DynamoDB::Errors::ServiceError => error
    puts "Unable to update item:"
    puts "#{error.message}"
end