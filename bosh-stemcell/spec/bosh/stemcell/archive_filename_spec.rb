require 'spec_helper'
require 'bosh/stemcell/archive_filename'
require 'bosh/stemcell/definition'

module Bosh::Stemcell
  describe ArchiveFilename do
    let(:version) { '007' }
    let(:infrastructure) do
      instance_double('Bosh::Stemcell::Infrastructure::Base',
                      name: 'INFRASTRUCTURE',
                      hypervisor: 'HYPERVISOR')
    end
    let(:operating_system) do
      instance_double('Bosh::Stemcell::OperatingSystem::Base',
                      name: 'OPERATING_SYSTEM',
                      version: 'OPERATING_SYSTEM_VERSION',
      )
    end
    let(:agent) do
      instance_double(
        'Bosh::Stemcell::Agent::Go',
        name: 'go'
      )
    end
    let(:definition) do
      instance_double(
        'Bosh::Stemcell::Definition',
        stemcell_name: 'fake-stemcell-name',
        infrastructure: instance_double('Bosh::Stemcell::Infrastructure::Base', default_disk_format: 'iso'),
      )
    end

    let(:disk_format) { 'iso' }
    subject(:archive_filename) do
      ArchiveFilename.new(version, definition, 'FAKE_NAME', disk_format)
    end

    describe '#to_s' do
      it 'includes name, version, stemcell name' do
        expect(archive_filename.to_s).to eq ("FAKE_NAME-007-fake-stemcell-name.tgz")
      end
    end
  end
end
