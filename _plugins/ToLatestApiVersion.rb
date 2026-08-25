module Jekyll
    module ToLatestApiVersion
        def to_latest_api_version(url_path)
            collection_url_path, subpath, fragment = parse(url_path)
            path = latest_url_path(@context, collection_url_path, subpath)
            if fragment
                path + fragment
            else
                path
            end
        end

        private

        def parse(url_path)
            # match /prefix/edge/subpath#fragment, ignoring version and allowing
            # both prefix and subpath to contain slashes
            m = url_path.match(%r|^/(.+)/edge/([^#]+)(#.*)?$|)
            unless m
                raise "Invalid url path: #{url_path}"
            end

            collection_url_path = m[1]
            subpath = m[2]
            fragment = m[3]
            [collection_url_path, subpath, fragment]
        end

        # If the latest version in the specified collection has a document with
        # the specified subpath, return it. Otherwise raise an error.
        def latest_url_path(context, collection_url_path, subpath)
            coll = context.registers[:site].collections.values
                .find { |c|
                    c.url_template.sub(/\/:path$/, "") == collection_url_path
                }

            unless coll
                raise "No collection with path \"${collection_url_path}\""
            end

            v = latest_version(coll)
            p = "#{coll.relative_directory}/#{v}/#{subpath}"
            d = coll.docs.find { |d| d.relative_path == p }

            unless d
                raise "No document with path #{subpath} in the latest #{collection_url_path} version"
            end

            d.url
        end

        def latest_version(coll)
            coll.docs
                .map { |doc|
                    doc.relative_path
                        .sub("#{coll.relative_directory}/", "")
                        .split("/")[0]
                }
                .filter { |v| v != 'edge' }
                .uniq
                .max_by { |v| Gem::Version.new(v) }
        end
    end
end

Liquid::Template.register_filter(Jekyll::ToLatestApiVersion)
