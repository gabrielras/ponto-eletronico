# frozen_string_literal: true
require 'business_time'

module Collaborator
  module PointPresences
    class Dashboard < Actor
      input :year, type: Integer
      input :month, type: Integer
      input :user, type: User

      output :data, type: Hash

      def call
        self.data = {
          banco_de_hora: banco_de_hora,
          total_horas_trabalhadas: total_horas_trabalhadas,
          total_de_faltas: total_de_faltas
        }
      end

      private

      def banco_de_hora
        result = dias_disponiveis(month, year)*60*60 - total_horas_trabalhadas*60

        horas = result / 3600
        minutos = (result % 3600) / 60
    
        return format('%02d:%02d', horas, minutos)
      end

      def total_horas_trabalhadas
        primeiro_dia = Date.new(year, month, 1)
        ultimo_dia = primeiro_dia.end_of_month
        number = PointPresence.joins(role: :user).where(user: { id: user.id }, schedule_time: 'final_time').where(created_at: primeiro_dia..ultimo_dia).count

        return number * total_horas
      end

      def total_de_faltas
        primeiro_dia = Date.new(year, month, 1)
        ultimo_dia = primeiro_dia.end_of_month
        presenca = PointPresence.joins(role: :user).where(user: { id:user.id }, schedule_time: 'final_time').where(created_at: primeiro_dia..ultimo_dia).count

        return dias_disponiveis_com_limite(month, year, Time.zone.now.day.to_i) - presenca
      end

      def total_horas
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
        return (a - b)/60
      end

      def dias_uteis
        primeiro_dia = Date.new(year, month, 1)
        ultimo_dia = primeiro_dia.end_of_month
        dias_uteis = 0

        primeiro_dia.upto(ultimo_dia) do |date|
          dias_uteis += 1 if date.workday?
        end
      end

      def diferenca_em_minutos(horario1, horario2)
        horas1, minutos1 = horario1.split(":").map(&:to_i)
        horas2, minutos2 = horario2.split(":").map(&:to_i)
      
        total_minutos1 = horas1 * 60 + minutos1
        total_minutos2 = horas2 * 60 + minutos2
      
        diferenca = total_minutos2 - total_minutos1
      
        diferenca.abs
      end

      def dias_disponiveis(mes, ano)
        dias_no_mes = Time.days_in_month(mes, year: ano)
        data_inicial = Date.new(ano, mes, 1)
        data_final = Date.new(ano, mes, dias_no_mes)
        
        disponiveis = 0
        (data_inicial..data_final).each do |data|
          disponiveis += 1 if schedule_disponivel?(data)
        end
        
        disponiveis
      end

      def dias_disponiveis_com_limite(mes, ano, data_limite)
        dias_no_mes = Time.days_in_month(mes, year: ano)
        data_inicial = Date.new(ano, mes, 1)
        data_final = Date.new(ano, mes, dias_no_mes)
        
        disponiveis = 0
        (data_inicial..data_final).each do |data|
          break if data > data_limite
          disponiveis += 1 if schedule_disponivel?(data)
        end
        
        disponiveis
      end

      def schedule_disponivel?(data)        
        case data.wday
        when 0
          schedule.sunday
        when 1
          schedule.monday
        when 2
          schedule.tuesday
        when 3
          schedule.wednesday
        when 4
          schedule.thursday
        when 5
          schedule.friday
        when 6
          schedule.saturday
        else
          false
        end
      end

      def schedule
        user.role.schedules.last
      end
    end
  end
end
