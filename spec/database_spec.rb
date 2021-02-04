require_relative '../database'

describe Database do
    let(:db_url) { 'postgres://localhost:5432/framework_dev'}
    let(:queries) do 
        {
            create_submission: %{
                insert into submissions(name)
                values ($1)
            },
            find_submissions: %{
                select * from submissions
                where name = $1
            }
        }
    end
    let(:db) { Database.connect(db_url, queries) }

    it "does not have SQL injection vulnerabilities" do
        name = "'; drop table submissions; --"
        expect { db.create_submission(name) }
        .to change { db.find_submissions(name).length }
        .by(1)
    end

    it "retrieves records that it has inserted" do
        db.create_submission('Alex')
        alex = db.find_submissions('Alex').fetch(0)
        expect(alex.name).to eq 'Alex'
    end
end