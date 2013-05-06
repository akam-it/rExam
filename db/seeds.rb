# encoding: UTF-8

User.create(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password')

["LPI", "Cisco", "RedHat", "Microsoft"].each do |l|
  Vendor.create!(:title => "#{l}")
end

["Linux administration", "Windows administration", "Networks"].each do |l|
  Category.create!(:title => "#{l}")
end

["Единственный выбор", "Множественный выбор"].each do |l|
  Type.create!(:title => "#{l}")
end

Exam.create(:category_id => 1, :vendor_id => 1, :title => 'Основы администрирования Linux', :number => '001-001', :pass_score => 60, :time_limit => 120, :description => 'Основы администрирования Linux')
Exam.create(:category_id => 2, :vendor_id => 4, :title => 'Second Exam', :number => '002-001', :pass_score => 90, :time_limit => 120, :description => 'Windows examination')

["Общая", "Управление процессами", "Файловая система", "Управление доступом", "Управление пользователями", "Драйверы и ядро", "Сетевые подключения"].each do |l|
  Section.create!(:exam_id => 1, :title => "#{l}")
end

Question.create(:type_id => 1, :section_id => 1, :title => 'Какую программу можно использовать для сканирования портов из Linux?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 1, :title => 'nmap', :is_correct => true)
Answer.create(:question_id => 1, :title => 'iptables', :is_correct => false)
Answer.create(:question_id => 1, :title => 'netcat', :is_correct => false)
Answer.create(:question_id => 1, :title => 'scanport', :is_correct => false)

Question.create(:type_id => 1, :section_id => 3, :title => 'В каком месте файловой системы должны находиться исходные тексты ядра Linux?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 2, :title => '/usr/src/linux', :is_correct => true)
Answer.create(:question_id => 2, :title => '/linux', :is_correct => false)
Answer.create(:question_id => 2, :title => '/lib/linux', :is_correct => false)
Answer.create(:question_id => 2, :title => '/home/linux', :is_correct => false)

Question.create(:type_id => 1, :section_id => 3, :title => 'Какая опция программы fsck заставит ее проверять файловые системы, описанные в файле /etc/fstab?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 3, :title => '-A', :is_correct => true)
Answer.create(:question_id => 3, :title => '-a', :is_correct => false)
Answer.create(:question_id => 3, :title => '--fstab', :is_correct => false)
Answer.create(:question_id => 3, :title => '-f', :is_correct => false)

Question.create(:type_id => 1, :section_id => 6, :title => 'Какая из команд используется для выбора опций ядра с использованием ncurses-интерфейса?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 4, :title => 'make menuconfig', :is_correct => true)
Answer.create(:question_id => 4, :title => 'make config', :is_correct => false)
Answer.create(:question_id => 4, :title => 'make', :is_correct => false)
Answer.create(:question_id => 4, :title => 'make xconfig', :is_correct => false)

Question.create(:type_id => 1, :section_id => 7, :title => 'На сколько подсетей будет разбита сеть класса С, если маска подсети 255.255.255.240?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 5, :title => '16', :is_correct => true)
Answer.create(:question_id => 5, :title => '2', :is_correct => false)
Answer.create(:question_id => 5, :title => '4', :is_correct => false)
Answer.create(:question_id => 5, :title => '6', :is_correct => false)
Answer.create(:question_id => 5, :title => '8', :is_correct => false)
Answer.create(:question_id => 5, :title => '32', :is_correct => false)
Answer.create(:question_id => 5, :title => '64', :is_correct => false)

Question.create(:type_id => 1, :section_id => 3, :title => 'Какой из перечисленных способов позволяет посмотреть смонтированные файловые системы?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 6, :title => 'mount', :is_correct => true)
Answer.create(:question_id => 6, :title => 'showmount', :is_correct => false)
Answer.create(:question_id => 6, :title => 'shm', :is_correct => false)
Answer.create(:question_id => 6, :title => 'mountshow', :is_correct => false)

Question.create(:type_id => 1, :section_id => 5, :title => 'Какая программа позволяет изменить пароль пользователя?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 7, :title => 'passwd', :is_correct => true)
Answer.create(:question_id => 7, :title => 'gpasswd', :is_correct => false)
Answer.create(:question_id => 7, :title => 'usermod', :is_correct => false)
Answer.create(:question_id => 7, :title => 'password', :is_correct => false)
Answer.create(:question_id => 7, :title => 'chpassword', :is_correct => false)

Question.create(:type_id => 1, :section_id => 5, :title => 'Какие права доступа должен иметь файл /etc/shadow?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 8, :title => '-rw-r-----', :is_correct => true)
Answer.create(:question_id => 8, :title => '-rw-r--r--', :is_correct => false)
Answer.create(:question_id => 8, :title => '-rw-------', :is_correct => false)
Answer.create(:question_id => 8, :title => '-rw-rw-r--', :is_correct => false)

Question.create(:type_id => 1, :section_id => 1, :title => 'Как называется конфигурационный файл загрузчика grub?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 9, :title => 'grub.conf', :is_correct => true)
Answer.create(:question_id => 9, :title => 'grub.cfg', :is_correct => false)
Answer.create(:question_id => 9, :title => 'menu.lst', :is_correct => false)
Answer.create(:question_id => 9, :title => 'loader.conf', :is_correct => false)

Question.create(:type_id => 1, :section_id => 3, :title => 'Какая программа позволяет разбить жесткий диск компьютера на разделы (partitions)?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 10, :title => 'fdisk', :is_correct => true)
Answer.create(:question_id => 10, :title => 'split', :is_correct => false)
Answer.create(:question_id => 10, :title => 'partiotion', :is_correct => false)
Answer.create(:question_id => 10, :title => 'prtman', :is_correct => false)

Question.create(:type_id => 1, :section_id => 6, :title => 'С помощью какой программы можно получить сведения о модуле ядра?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 11, :title => 'modinfo', :is_correct => true)
Answer.create(:question_id => 11, :title => 'modprobe', :is_correct => false)
Answer.create(:question_id => 11, :title => 'lsmod', :is_correct => false)
Answer.create(:question_id => 11, :title => 'depmod', :is_correct => false)

Question.create(:type_id => 1, :section_id => 3, :title => 'Какая опция программы mount заставит ее монтировать все файловые системы, описанные в файле /etc/fstab?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 12, :title => '-a', :is_correct => true)
Answer.create(:question_id => 12, :title => '-A', :is_correct => false)
Answer.create(:question_id => 12, :title => '--automount', :is_correct => false)
Answer.create(:question_id => 12, :title => '--fstab', :is_correct => false)

Question.create(:type_id => 1, :section_id => 3, :title => 'fdisk –l (Выберите верное утверждение)', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 13, :title => 'Показывает разделы на всех жестких дисках', :is_correct => true)
Answer.create(:question_id => 13, :title => 'Показывает, какие жесткие диски есть в системе', :is_correct => false)
Answer.create(:question_id => 13, :title => 'Такой опции у программы fdisk нет', :is_correct => false)
Answer.create(:question_id => 13, :title => 'Показывает только незанятое разделами (partition) место на диске', :is_correct => false)

Question.create(:type_id => 1, :section_id => 1, :title => 'Как называется конфигурационный файл ssh демона?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 14, :title => 'sshd_config', :is_correct => true)
Answer.create(:question_id => 14, :title => 'sshd.conf', :is_correct => false)
Answer.create(:question_id => 14, :title => 'sshd.cfg', :is_correct => false)
Answer.create(:question_id => 14, :title => 'ssh_config', :is_correct => false)

Question.create(:type_id => 1, :section_id => 5, :title => 'Файл /etc/shadow служит для ...?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 15, :title => 'Хранения пароля пользователя', :is_correct => true)
Answer.create(:question_id => 15, :title => 'Хранения дополнительной информации о пользователе', :is_correct => false)
Answer.create(:question_id => 15, :title => 'Хранения времени окончания действия учетной записи пользователя', :is_correct => false)
Answer.create(:question_id => 15, :title => 'Хранения домашней директории пользователя', :is_correct => false)

Question.create(:type_id => 1, :section_id => 7, :title => 'Какая из перечисленных ниже масок подсети является маской по умолчанию для сети класса B?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 16, :title => '255.255.0.0', :is_correct => true)
Answer.create(:question_id => 16, :title => '127.0.0.0', :is_correct => false)
Answer.create(:question_id => 16, :title => '255.255.255.0', :is_correct => false)
Answer.create(:question_id => 16, :title => '255.255.255.255', :is_correct => false)
Answer.create(:question_id => 16, :title => '255.0.0.0', :is_correct => false)

Question.create(:type_id => 1, :section_id => 6, :title => 'В каком месте файловой системы находятся скомпилированные модули ядра Linux? (x.x.x - версия ядра Linux)', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 17, :title => '/lib/modules/x.x.x/', :is_correct => true)
Answer.create(:question_id => 17, :title => '/kernel/modules/x.x.x/', :is_correct => false)
Answer.create(:question_id => 17, :title => '/var/lib/modules/x.x.x/', :is_correct => false)
Answer.create(:question_id => 17, :title => '/usr/lib/modules/x.x.x/', :is_correct => false)

Question.create(:type_id => 1, :section_id => 6, :title => 'Какая программа может удалять модуль из ядра Linux?', :difficult => 5, :allow_mix => true, :explanation => '')
Answer.create(:question_id => 18, :title => 'rmmod', :is_correct => true)
Answer.create(:question_id => 18, :title => 'lsmod', :is_correct => false)
Answer.create(:question_id => 18, :title => 'depmod', :is_correct => false)
Answer.create(:question_id => 18, :title => 'delmod', :is_correct => false)
