module Travis
  module Addons
    module LibratoAnnotations
      class Task < Travis::Task
        def targets
          params[:targets]
        end

        def process
          http.basic_auth(config[:email], config[:token])

          Array(targets).each do |target|
            store_annotation(target)
          end
        end

        def store_annotation(target)
          http.post(annotation_url(target)) do |request|
            r.body = MultiJson.encode(annotation_payload)
            r.headers['Content-Type'] = 'application/json'
          end
        end

        def annotation_url(target)
          "https://metrics-api.librato.com/v1/annotations/#{target}"
        end

        def annotation_payload
          @annotation_payload ||= {
            title: "Travis build #{build[:number]} #{build_result}",
            description: "Commit #{commit[:sha][0..6]} by #{commit[:author_email]}.",
            source: 'travisci',
            links: [
              {
                rel: 'travisci',
                link: build_url,
                label: 'Travis Build'
              }, {
                rel: 'github',
                link: commit[:compare_url],
                label: 'Compare diffs'
              }
            ]
          }
        end

        def build_result
          build_passed? ? 'passed' : 'failed'
        end

        def build_passed?
          build[:state] == 'passed'
        end

        def config
          build[:config][:notifications][:librato]
        end
      end
    end
  end
end
