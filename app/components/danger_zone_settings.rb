# frozen_string_literal: true

module Components
  class DangerZoneSettings < Components::Base
    prop :user, User, reader: :private

    def view_template
      turbo_frame_tag 'settings-danger-content' do
        h2(class: 'text-xl font-semibold mb-6 text-white flex items-center') do
          Lucide::TriangleAlert class: 'h-5 w-5 mr-2 text-red-400'
          'Danger Zone'
        end

        div(class: 'p-6 rounded-lg bg-red-950/20 border border-red-500/20 space-y-6') do
          render_account_deletion
          render_data_export
        end
      end
    end

    private

    def render_account_deletion
      div do
        h3(class: 'text-lg font-medium text-red-300') { 'Delete Account' }
        p(class: 'mt-4 text-white/70 text-sm') { 'Permanently delete your account and all associated data. This action cannot be undone.' }

        div(class: 'mt-4') do
          RubyUI::Button(variant: :destructive) do
            'Delete Account'
          end
        end
      end
    end

    def render_data_export
      div(class: 'pt-6 border-t border-red-500/10') do
        h3(class: 'text-lg font-medium text-amber-300') { 'Export Your Data' }
        p(class: 'mt-4 text-white/70 text-sm') { 'Download all your personal data, including profile information, messages, and activities.' }

        div(class: 'mt-4') do
          RubyUI::Button(variant: :outline) do
            Lucide::Download class: 'h-4 w-4 mr-2'
            'Export Data'
          end
        end
      end
    end
  end
end
