create table if not exists users (
    id bigint not null auto_increment,
    created_at datetime(6) not null,
    updated_at datetime(6) not null,
    email varchar(150) not null,
    full_name varchar(120) not null,
    password varchar(255) not null,
    email_verified bit not null,
    role varchar(30) not null,
    plan varchar(30) not null,
    primary key (id),
    constraint uk_users_email unique (email)
);

create table if not exists profiles (
    id bigint not null auto_increment,
    created_at datetime(6) not null,
    updated_at datetime(6) not null,
    user_id bigint not null,
    phone_number varchar(20),
    avatar_url varchar(500),
    primary_sport varchar(50),
    skill_level varchar(20),
    primary key (id),
    constraint uk_profiles_user unique (user_id)
);

create table if not exists sport_preferences (
    id bigint not null auto_increment,
    profile_id bigint not null,
    sport_name varchar(50) not null,
    skill_level varchar(20) not null,
    primary key (id),
    constraint fk_sport_preferences_profile foreign key (profile_id) references profiles (id)
);

create table if not exists profile_availability (
    profile_id bigint not null,
    time_slot varchar(20),
    constraint fk_profile_availability_profile foreign key (profile_id) references profiles (id)
);

create table if not exists courts (
    id bigint not null auto_increment,
    created_at datetime(6) not null,
    updated_at datetime(6) not null,
    owner_id bigint not null,
    name varchar(120) not null,
    complex_name varchar(120),
    description varchar(500),
    address varchar(240) not null,
    district varchar(80) not null,
    latitude double,
    longitude double,
    price_per_hour decimal(10, 2) not null,
    active bit not null,
    published bit not null,
    available_for_reservations bit not null,
    main_image_url varchar(255),
    primary key (id)
);

create table if not exists court_sports (
    court_id bigint not null,
    sport varchar(80) not null,
    constraint fk_court_sports_court foreign key (court_id) references courts (id)
);

create table if not exists court_schedules (
    court_id bigint not null,
    schedule varchar(30) not null,
    constraint fk_court_schedules_court foreign key (court_id) references courts (id)
);

create table if not exists court_images (
    court_id bigint not null,
    image_url varchar(255),
    constraint fk_court_images_court foreign key (court_id) references courts (id)
);

create table if not exists court_services (
    court_id bigint not null,
    service varchar(100),
    constraint fk_court_services_court foreign key (court_id) references courts (id)
);

create table if not exists court_features (
    court_id bigint not null,
    feature varchar(100),
    constraint fk_court_features_court foreign key (court_id) references courts (id)
);

create table if not exists court_reservations (
    id bigint not null auto_increment,
    created_at datetime(6) not null,
    updated_at datetime(6) not null,
    user_id bigint not null,
    court_id bigint not null,
    reservation_date date not null,
    start_time time not null,
    end_time time not null,
    price decimal(10, 2) not null,
    currency varchar(3) not null,
    provider_reference varchar(255),
    payment_idempotency_key varchar(255),
    status varchar(30) not null,
    payment_status varchar(30) not null,
    reservation_created_at datetime(6) not null,
    primary key (id),
    constraint uk_reservations_provider_reference unique (provider_reference),
    constraint uk_reservations_idempotency_key unique (payment_idempotency_key)
);

create table if not exists matches (
    id bigint not null auto_increment,
    created_at datetime(6) not null,
    updated_at datetime(6) not null,
    organizer_id bigint not null,
    court_reservation_id bigint,
    sport varchar(50) not null,
    title varchar(100) not null,
    description varchar(500),
    address varchar(200) not null,
    match_date datetime(6) not null,
    total_slots integer not null,
    price decimal(10, 2),
    latitude double,
    longitude double,
    status varchar(20) not null,
    requires_player_payment bit not null,
    yape_phone varchar(20),
    player_payment_amount decimal(10, 2),
    primary key (id)
);

create table if not exists match_participants (
    match_id bigint not null,
    user_id bigint,
    constraint fk_match_participants_match foreign key (match_id) references matches (id)
);

create table if not exists player_join_requests (
    id bigint not null auto_increment,
    created_at datetime(6) not null,
    updated_at datetime(6) not null,
    match_id bigint not null,
    player_id bigint not null,
    proof_storage_key varchar(500) not null,
    original_file_name varchar(200),
    content_type varchar(80) not null,
    amount decimal(10, 2) not null,
    status varchar(40) not null,
    submitted_at datetime(6) not null,
    reviewed_at datetime(6),
    reviewed_by bigint,
    rejection_reason varchar(500),
    primary key (id)
);

create index idx_profiles_user on profiles (user_id);
create index idx_courts_owner on courts (owner_id);
create index idx_reservations_court_date on court_reservations (court_id, reservation_date);
create index idx_matches_organizer on matches (organizer_id);
create index idx_matches_status_date on matches (status, match_date);
create index idx_join_requests_match on player_join_requests (match_id);
create index idx_join_requests_player on player_join_requests (player_id);
