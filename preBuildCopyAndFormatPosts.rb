require 'find'
require 'json'

source = './tasks/'
target = './_posts'

def head(fields)
  res = "---\n"
  fields.each do |key,value|
    if value.kind_of?(Array)
      value = '[' + value.join(', ') + ']'
    end
    res += "#{key}: #{value}\n"
  end
  res += "---\n"
end 

md_file_paths = []
Find.find(source) do |path|
  md_file_paths << path if path =~ /.+_.+_.+_.+\.md$/
end

iToIndex = { 0 => 'categories', 1 => 'subcategories', 2 => 'title', 3 => 'id'}
for oriPath in md_file_paths
  i = 0  
  res = {'layout'=> 'postenhanced'}
  path = oriPath[0..(oriPath.length()-4)].split('/')[-1]
  for g1 in path.split('_')
    if i < 2
      value = g1.split('-')
    else
      value = g1
    end
    res[iToIndex[i]] = value
    i = i + 1
  end
  filename = "#{target}/2020-03-21-#{res['id']}.md" 
  File.open(filename, "w")
  File.write(filename, head(res)+File.read(oriPath))
end
