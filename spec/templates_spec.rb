require_relative '../templates'

class Templates
    describe Templates do
        it 'renders templates' do
            source = <<~END
                div
                  p
                    | User:
                  p
                    =  email
            END
            expected = <<~END
            <div>
              <p>
                User:
              </p>
              <p>
                alex@example.com
              </p>
            </div>
            END
            rendered = Template.new(source).render(email: 'alex@example.com')
            expect(rendered).to eq expected
        end
    end
end