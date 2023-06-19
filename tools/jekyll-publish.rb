#!/usr/bin/env ruby

# Usage:
#   jekyll-publish.rb _drafts/xxx-xxx.md , or document in anywhere.
# it will append a jekyll header in document.

require 'ostruct'
require 'optparse'
require 'yaml'

# strftime("%F %T %z") => "2022-10-27 20:21:15 +0800"

class DocInfo
  attr_reader :doc_text, :title, :date, :yaml_info
  def initialize(doc_path)
    fail "doc #{doc_path} not exist!" if not File.exist? doc_path
    draft_fh  = File.open(doc_path)
    @doc_text = draft_fh.read()
    get_yaml_info(doc_text)
    @title = @yaml_info['title']
    @title ||= find_title(doc_text) if not @title
    @date  = @yaml_info['date'].to_s
    @date  ||= draft_fh.stat.mtime.strftime("%F")
  end

  def find_title(doc_text)
    title_lines = doc_text.lines.grep(/^#\s/)
    fail "find title failed." if title_lines.empty?
    title_lines.first.sub(/#\s+(.+?)\s*$/, '\1')
  end

  def strip_yaml_head()
    lines = @doc_text.lines.drop_while{ |l| l.chomp != '---' }.drop(1)
    lines = lines.drop_while{ |l| l.chomp != '---' }.drop(1)
    lines = lines.drop_while{ |l| l.strip == '' }  # drop space
    @doc_text = lines.join('')
  end

  def get_yaml_info(doc_text)
    data = YAML.load(doc_text)
    @yaml_info = data || Hash.new
    if data
      @yaml_date = data["date"]
      @title = data["title"] || @title
      strip_yaml_head()
    end
  end

end

def gen_header(out, opts)
  date_str = opts.date || Time.now.strftime("%F %T %z")
  tags_str = opts.tags ? opts.tags.join(' ') : nil
  out.puts '---'
  out.puts "title:  \"#{opts.title}\""
  out.puts "layout:  #{opts.layout}"
  out.puts "date:    #{date_str}"
  out.puts "categories: " + opts.categories.join(' ')
  out.puts "tags:    #{tags_str}" if tags_str
  out.puts '---'
  out.puts ''
end

def publish(doc_path, opts)
  doc = DocInfo.new(doc_path)

  #date_prefix = IO.popen('date  "+%F-"').read.chomp
  date_prefix = doc.date + '-'
  base_name = File.basename(doc_path)
  post_file = File.join('_posts', date_prefix + base_name)
  fail "_post not exist!" if not Dir.exist? '_posts'
  fail "post #{post_file} exist!" if !opts.force and File.exist? post_file

  opts.title ||= doc.title
  opts.date  ||= doc.date
  opts.layout ||= doc.yaml_info['layout']
  opts.categories ||= doc.yaml_info['categories']
  opts.tags   ||= doc.yaml_info['tags']

  out = File.open(post_file, "w")
  fail "write #{post_file} failed." if not out
  gen_header(out, opts)
  out.write(doc.doc_text)
  out.close
end

# main
opts = OpenStruct.new
opts.categories = 'jekyll,update'
OptionParser.new do |op|
  op.banner = "jekyll-publish.rb [options] doc-path"
  op.on('-t', '--title TITLE', "set title, default is first H1 in doc")
  op.on('-l', '--layout LAYOUT', "set layout, default is 'post'")
  op.on('-c', '--categories C,C,...', "set categories, default is jekyll,update")
  op.on('--add-categories C,C,...', "append categories")
  op.on('--tags TAG,TAG,...', "set tags, default is empty")
  op.on('-f', '--force', "force update post if it exists.")
end.parse!(into: opts)

opts.tags = opts.tags.split(',') if opts.tags
opts.categories = opts.categories.split(',') if opts.categories
opts.categories.append(opts['add-categories'].split(',')) if opts['add-categories']
opts.layout ||= 'post'

fail "need doc to publish" if ARGV.empty?

ARGV.each do |doc|
  publish(doc, opts)
end

