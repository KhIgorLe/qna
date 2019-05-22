QNA - Application to create a question and get answers to them.

Goal- Getting information from the community on an interesting topic;

Technology:
 - tdd/bdd testing(rspec, Capybara);
 - Ajax - add answer for question;
 - ActiveStorage - creates, stores locally or in the cloud attachments for questions or answers
 - Nested forms and polymorphic association;
 - ActionCable - adds answers to pages of other user sessions without refreshing the page;
 - OAuth - authentication through social network;
 - CanCanCan - authorization in the application;
 - Rest API, doorkeeper, ActiveModelSerializer:
   - profile user;
   - list all profiles users;
   - answers list to question;
   ...
   
 - AciveJob, Sidekiq, Whenever - mailing notifications;
 - ThinkingSphinx - search in the application;
 - Deploy:
    -Capistrano;
    - Unicorn;
    - Nginx;
    - Monit;
    - Backup;
