# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render Views::Home::Index.new(activities:, realms:)
  end

  def show
  end

  def sidenav
    render Views::Home::Sidenav.new(realms:, pinned_realms:, my_realms:, direct_messages:,)
  end

  private

  def realms
    @realms ||= Realm.left_joins(:memberships)
      .select('realms.*, COUNT(memberships.id) as member_count')
      .where(is_public: true)
      .group('realms.id')
      .order(Arel.sql('COUNT(memberships.id) DESC'))
      .limit(6)
  end

  def pinned_realms
    @pinned_realms ||= Current.user.realms
      .joins(:memberships)
      .where(memberships: { user_id: Current.user.id })
      .select('realms.*, memberships.joined_at')
      .order(Arel.sql('memberships.joined_at ASC'))
      .limit(2)
  end

  def my_realms
    @my_realms ||= Current.user.realms
      .where.not(id: pinned_realms.map(&:id))
      .limit(5)
  end

  def direct_messages
    @direct_messages ||= DirectMessageThread
      .joins(:participants)
      .where(direct_message_participants: { user_id: Current.user.id })
      .joins("LEFT JOIN (
      SELECT messageable_id, MAX(created_at) as last_message_at
      FROM messages
      WHERE messageable_type = 'DirectMessageThread'
      GROUP BY messageable_id
    ) latest_messages ON latest_messages.messageable_id = direct_message_threads.id")
      .select('direct_message_threads.*, COALESCE(latest_messages.last_message_at, direct_message_threads.created_at) as sort_date')
      .order(Arel.sql('sort_date DESC'))
      .limit(3)
  end

  def activities
    @activities ||= Activity
      .includes(:user)
      .order(created_at: :desc)
      .limit(5)
  end
end
