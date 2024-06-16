Elasticsearch::Model.client = Elasticsearch::Client.new(
  hosts: ENV['ELASTICSEARCH_URL'] || 'http://elasticsearch:9200'
)
