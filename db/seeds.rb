# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
puts 'Clearing existing data...'
puts 'Cleaning the Shire...'
User.destroy_all
Realm.destroy_all
Channel.destroy_all
Membership.destroy_all
Message.destroy_all
DirectMessageThread.destroy_all
DirectMessageParticipant.destroy_all
Activity.destroy_all

# Create users
puts 'Creating users...'
puts 'Assembling the Fellowship...'

users = [
  { username: 'luffy', email: 'luffy@example.com', password: 'password123456!' },
  { username: 'Aragorn', email: 'strider@gondor.com', password: 'IsildursHeir1!!' },
  { username: 'Frodo', email: 'ringbearer@shire.com', password: 'SecretlyMine!!' },
  { username: 'Gandalf', email: 'greytowht@istari.com', password: 'YouShallNotPass!!' },
  { username: 'Legolas', email: 'elf@mirkwood.com', password: 'StillCounting42!!' },
  { username: 'Gimli', email: 'axe@erebor.com', password: 'AndMyAxe123!!' },
  { username: 'LuffyKing', email: 'pirate.king@sunny.com', password: 'MeatIsLife5!!' },
  { username: 'ZoroLost', email: 'santoryu@wano.com', password: 'WrongDirection!!' },
  { username: 'Blackbeard', email: 'marshall.teach@darkness.com', password: 'TwoDevilFruits!!' },
  { username: 'Thrall', email: 'warchief@orgrimmar.com', password: 'ForTheHorde!!' },
  { username: 'Sylvanas', email: 'banshee@undercity.com', password: 'DarkLady4ever!!' },
  { username: 'Arthas', email: 'lich.king@northrend.com', password: 'FrostmourneHungers!!' },
  { username: 'Jaina', email: 'proudmoore@theramore.com', password: 'ArcaneBlast!!' },
]

created_users = users.map do |user_attributes|
  user = User.create!(
    email: user_attributes[:email],
    password: user_attributes[:password],
    password_confirmation: user_attributes[:password]
  )

  # Create UserProfile for each user
  UserProfile.create!(
    user:,
    username: user_attributes[:username],
    display_name: user_attributes[:username],
    gaming_status: ['online', 'away', 'busy', 'offline'].sample
  )

  user
end

# Assign the first user as Current.user for testing
current_user = created_users.first
puts "Current user for testing: #{current_user.email}"
puts 'The Ring-bearer sets forth on the Quest...'

# Create realms
puts 'Creating realms...'
puts 'Forging the Rings of Power...'

realms = [
  {
    name: 'Fellowship of Gamers',
    description: 'One does not simply walk into a raid without preparation.',
    is_public: true,
  },
  {
    name: 'Mines of Moria',
    description: 'Speak friend and enter. A dark place full of treasures and dangers.',
    is_public: true,
  },
  {
    name: 'Grand Line Adventures',
    description: 'Set sail for the greatest gaming adventures in search of the One Piece!',
    is_public: true,
  },
  {
    name: 'Wano Kuni Society',
    description: 'A closed server for the land of samurai. Share techniques and stories.',
    is_public: false,
  },
  {
    name: 'Azeroth United',
    description: 'For the Alliance! For the Horde! Or just for the loot...',
    is_public: true,
  },
  {
    name: "Lich King's Lounge",
    description: 'Frostmourne hungers... for better gear drops and PvP strategies.',
    is_public: true,
  },
  {
    name: 'Rivendell Retreat',
    description: 'A sanctuary for elven wisdom about game lore and storytelling.',
    is_public: true,
  },
  {
    name: 'Thousand Sunny Crew',
    description: 'Nakama welcome! Discuss strategies to conquer the gaming seas.',
    is_public: false,
  },
  {
    name: 'Mordor Tactics',
    description: 'One does not simply walk into PvP without proper builds.',
    is_public: true,
  },
  {
    name: 'Stormwind Strategies',
    description: 'Alliance gamers sharing raid tactics and dungeon guides.',
    is_public: true,
  },
  {
    name: 'Enies Lobby Escapades',
    description: 'Breaking into the most difficult games and conquering them together.',
    is_public: true,
  },
  {
    name: 'Darnassus Design Guild',
    description: 'Night elves and friends crafting beautiful in-game creations.',
    is_public: true,
  },
]

created_realms = realms.map do |realm_attributes|
  # Assign a random user as the owner, but weight towards current_user
  owner = (rand(10) < 3) ? current_user : created_users.sample

  realm = Realm.create!(
    name: realm_attributes[:name],
    description: realm_attributes[:description],
    is_public: realm_attributes[:is_public],
    owner:
  )

  # Create default channels for each realm
  Channel.create!(realm:, name: 'general', description: 'General discussion', channel_type: 'text', is_private: false)
  Channel.create!(realm:, name: 'strategy', description: 'Strategy discussion', channel_type: 'text', is_private: false)
  Channel.create!(realm:, name: 'memes', description: 'Gaming memes', channel_type: 'text', is_private: false)
  Channel.create!(realm:, name: 'voice-chat', description: 'Voice chat', channel_type: 'voice', is_private: false)

  # Create memberships for random users (always include owner)
  members = [owner]

  # Add 3-8 random members to each realm
  members += created_users.reject { |u| u == owner }.sample(rand(3..8))
  members.uniq!

  members.each do |member|
    role = (member == owner) ? 'admin' : ['member', 'moderator'].sample
    Membership.create!(
      user: member,
      membershipable: realm,
      member_role: role,
      joined_at: rand(1..60).days.ago
    )
  end

  realm
end

# Set up particular realms for the current user (pinned realms)
puts 'Setting up pinned realms for current user...'
puts 'Crafting the One Ring to rule them all...'

# Ensure current user has membership in these realms
fellowship_realm = created_realms.find { |r| r.name == 'Fellowship of Gamers' }
mines_realm = created_realms.find { |r| r.name == 'Mines of Moria' }

unless fellowship_realm.nil?
  Membership.where(user: current_user, membershipable: fellowship_realm).first_or_create!(
    member_role: 'admin',
    joined_at: 60.days.ago
  )
end

unless mines_realm.nil?
  Membership.where(user: current_user, membershipable: mines_realm).first_or_create!(
    member_role: 'moderator',
    joined_at: 45.days.ago
  )
end

# Create messages in channels
puts 'Creating messages in channels...'
puts 'Writing in the Book of Mazarbul...'

message_contents = [
  'You have my sword!',
  'And my bow!',
  'AND MY AXE!',
  'One does not simply walk into this game without dying.',
  'Fly, you fools! The boss is coming!',
  "I'm going to be the king of the pirates!",
  'Gomu Gomu no Strategy!',
  'The Will of D carries on through these gaming sessions.',
  "Lok'tar Ogar! Victory or death in this battleground!",
  'For the Alliance!',
  'That dungeon was merely a setback!',
  'The Light will forge you a new weapon.',
  'Even the smallest gamer can change the course of a raid.',
  'Three raids for the Elven-kings under the sky...',
  'Seven wipes for the Dwarf-lords in their halls of stone...',
  'Nine guild members doomed to disconnect...',
  'One Raid Leader to rule them all!',
  'My precious... legendary drop...',
  'A wizard is never late to a raid, nor is he early. He arrives precisely when he means to!',
  'I will be the Pirate King of this server!',
  'Just waiting for the next expansion to drop like the Red Wedding.',
]

# Add messages to channels
created_realms.each do |realm|
  realm.channels.each do |channel|
    next if channel.channel_type != 'text'

    # Add 5-20 messages per channel
    rand(5..20).times do
      # Get random member of this realm
      membership = Membership.where(membershipable: realm).sample
      next unless membership

      Message.create!(
        user: membership.user,
        content: message_contents.sample,
        messageable: channel,
        created_at: rand(1..30).days.ago
      )
    end
  end
end

# Create direct message threads
puts 'Creating direct message threads...'
puts 'Sending ravens across Westeros...'

# Create DM threads for current_user with 3-5 other users
dm_partners = created_users.reject { |u| u == current_user }.sample(rand(3..5))

dm_partners.each do |partner|
  # Create thread
  thread = DirectMessageThread.create!

  # Add participants
  DirectMessageParticipant.create!(direct_message_thread: thread, user: current_user)
  DirectMessageParticipant.create!(direct_message_thread: thread, user: partner)

  # Add messages
  rand(3..10).times do
    sender = [current_user, partner].sample
    Message.create!(
      user: sender,
      content: message_contents.sample,
      messageable: thread,
      created_at: rand(1..15).days.ago
    )
  end
end

# Create activities
puts 'Creating activities...'
puts 'Recording tales in the Red Book of Westmarch...'

activity_actions = ['joined', 'posted in', 'created an event in', 'invited friends to', 'shared content from', 'achieved a milestone in']

30.times do
  user = created_users.sample
  realm = created_realms.sample
  action = activity_actions.sample

  Activity.create!(
    user:,
    action:,
    target: realm,
    target_name: realm.name,
    created_at: rand(1..7).days.ago
  )
end

puts 'Seed completed!'
puts 'The Ring has been destroyed in Mount Doom. Middle Earth is saved.'
puts "Seeds created #{User.count} users, #{Realm.count} realms, #{Channel.count} channels, #{Message.count} messages, and #{Activity.count} activities."
