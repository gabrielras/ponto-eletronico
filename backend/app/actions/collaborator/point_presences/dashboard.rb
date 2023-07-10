# frozen_string_literal: true
require 'active_support/time'

module Collaborator
  module PointPresences
    class Dashboard < Actor
      input :user, type: User

      output :data, type: Hash

      def call
        banco_de_minutos = 0
        total_minutos_trabalhados = 0
        total_de_faltas = 0

        current_time = Time.zone.now.beginning_of_month

        while current_time <= Time.zone.now
          result = Search.result(user: user, date: current_time.to_date)
          if result.data.present?
            banco_de_minutos = banco_de_minutos + tempo_de_trabalho_padrao_em_minutos(result.schedule)
            tempo_total = result.try(:data).try(:[], 0).try(:[], :tempo_total) || ""
            total_minutos_trabalhados = total_minutos_trabalhados + converter_tempo_para_minutos(tempo_total)
            total_de_faltas += 1 if tempo_total != ""
          end
          current_time += 1.day
        end

        self.data = {
          banco_de_hora: converter_minutos_para_tempo(banco_de_minutos - total_minutos_trabalhados),
          total_horas_trabalhadas: converter_minutos_para_tempo(total_minutos_trabalhados),
          total_de_faltas: total_de_faltas
        }
      rescue => e
        fail!(error: "Houve um erro: #{e.message}")
      end

      private

      def tempo_de_trabalho_padrao_em_minutos(schedule = nil)
        return 0 if schedule.nil?
        a = diferenca_em_minutos(
          "#{schedule.start_time_hour}:#{schedule.start_time_minute}",
          "#{schedule.final_time_hour}:#{schedule.final_time_minute}"
        )
        b = 0
        if schedule.final_interval_hour.present?
          b = diferenca_em_minutos(
            "#{schedule.initial_interval_hour}:#{schedule.initial_interval_minute}",
            "#{schedule.final_interval_hour}:#{schedule.final_interval_minute}"
          )
        end
        return (a - b)
      end

      def diferenca_em_minutos(horario1, horario2)
        horas1, minutos1 = horario1.split(":").map(&:to_i)
        horas2, minutos2 = horario2.split(":").map(&:to_i)
      
        total_minutos1 = horas1 * 60 + minutos1
        total_minutos2 = horas2 * 60 + minutos2
      
        diferenca = total_minutos2 - total_minutos1
      
        diferenca.abs
      end

      def converter_tempo_para_minutos(tempo)
        return 0 if tempo == ""

        horas, minutos = tempo.split(':').map(&:to_i)
        minutos_totais = horas * 60 + minutos
        return minutos_totais
      end
      
      def converter_minutos_para_tempo(minutos)
        horas = minutos / 60
        minutos = minutos % 60
        tempo = "#{horas}:#{minutos.to_s.rjust(2, '0')}"
        return tempo
      end
    end
  end
end
