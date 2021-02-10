require_relative '../database'

describe Database do
    let(:db_url) { 'postgres://localhost:5432/framework_dev'}
    let(:queries) do 
        {
            create: %{
                create table submissions (name text, email text)
            },
            drop: %{
                drop table if exists submissions;
            },
            create_submission: %{
                insert into submissions(name, email)
                values ({name}, {email})
            },
            find_submissions: %{
                select * from submissions
                where name = {name}
            }
        }
    end
    let(:db) { Database.connect(db_url, queries) }

    before do
        db.drop
        db.create
    end

    it "does not have SQL injection vulnerabilities" do
        name = "'; drop table submissions; --"
        email = 'alex@example.com'
        expect { db.create_submission(name: name, email: email) }
        .to change { db.find_submissions(name: name).length }
        .by(1)
    end

    it "retrieves records that it has inserted" do
        db.create_submission(name: 'Alex', 
                             email: 'alex@example.com')
        alex = db.find_submissions(name: 'Alex').fetch(0)
        expect(alex.name).to eq 'Alex'
    end

    it "doesn't care about order of params" do
        db.create_submission(email: 'alex@example.com', 
                             name: 'Alex')
        alex = db.find_submissions(name: 'Alex').fetch(0)
        expect(alex.name).to eq 'Alex'
    end
end