QUERIES = {
    all_submissions: %{
        select * from submissions
    },

    find_submission_by_name: %{
        select * from submissions
        where name = {name}
    }
}