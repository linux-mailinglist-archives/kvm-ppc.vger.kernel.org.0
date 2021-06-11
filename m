Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4BE3A431F
	for <lists+kvm-ppc@lfdr.de>; Fri, 11 Jun 2021 15:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhFKNhR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 11 Jun 2021 09:37:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230187AbhFKNhP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 11 Jun 2021 09:37:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623418517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zlTvKdwzw5MkeEEEC9I9PiSc9XRaRFcAGdPS/4M7/T4=;
        b=dUWD1BmHEtOA2cc+9VTYc77H++bHZqqdlcEfOPKI1BfQ3uSC+x4Ip9wk/9CD7UC7m2YvpZ
        Jsoq4eScLSKH2Twn8pFO5KFyLWk/9Uk4MRelKAglI3ea+8DeSTckRsM330BZyKWOKehH/g
        GPDsiV2lMY06FInpjblurbAN0ByPF5I=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-wA2VSecOP1Ohr_Dw39kfRQ-1; Fri, 11 Jun 2021 09:35:16 -0400
X-MC-Unique: wA2VSecOP1Ohr_Dw39kfRQ-1
Received: by mail-wr1-f71.google.com with SMTP id z4-20020adfe5440000b0290114f89c9931so2634544wrm.17
        for <kvm-ppc@vger.kernel.org>; Fri, 11 Jun 2021 06:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zlTvKdwzw5MkeEEEC9I9PiSc9XRaRFcAGdPS/4M7/T4=;
        b=KLAsUyw2Dt0nB7NQYByUutLhQEzSiW7UBa4lyKAJE5BqjSqfjBhpng+m2a1GmgJxqE
         nWX+G9KweUHuUj0aEjV4v1cpYxi1FI9q+JQuczW4kntbRL1zTyzb3xID9AJq+quSpP1Y
         b+puJhlcxBS1GpLDP8fJmhxK7whnEmgqwoJ3WRnMfJ8yykzTFyhPv+BbnCZV1kM5dz1i
         42XXZkwLvCiwmpW60uQDiZVG2ZrnQ9wCZ13AydkaIoP+1ijRacTQpRFf7ookzyyDI6LA
         VSAdKoyG+xrYQcPnVwmPjvJsWbUsKCUThVKUVQCwS0H3+b05CCS238tBK6y6MVuPit8+
         K21A==
X-Gm-Message-State: AOAM531YFwwVES+CJi05kapAchJjIVVDlPkXeua8d2rDLminzKohvF23
        t7UKVSRgtdZe+7xtxz9yH73JjjH1+xriIvVB2HGUJhxCa/3fi9XlLY1AkipIZakmv2d4l9FMxrP
        Gv79Pa0OTGerZSlGMiA==
X-Received: by 2002:a5d:59a9:: with SMTP id p9mr4119004wrr.86.1623418499469;
        Fri, 11 Jun 2021 06:34:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQM71M7BxbgLxkAQ6Zmo10Dt54e39XGmZG2f98CnpQkRKj9ZJdrEctz2F/sjq+A79DdtQBVQ==
X-Received: by 2002:a5d:59a9:: with SMTP id p9mr4118955wrr.86.1623418499200;
        Fri, 11 Jun 2021 06:34:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t4sm7169792wru.53.2021.06.11.06.34.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 06:34:58 -0700 (PDT)
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20210611124624.1404010-1-jingzhangos@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v8 0/4] KVM statistics data fd-based binary interface
Message-ID: <d9d440f0-ac2d-5a90-4e90-5eaa365f422e@redhat.com>
Date:   Fri, 11 Jun 2021 15:34:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210611124624.1404010-1-jingzhangos@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 11/06/21 14:46, Jing Zhang wrote:
> This patchset provides a file descriptor for every VM and VCPU to read
> KVM statistics data in binary format.
> It is meant to provide a lightweight, flexible, scalable and efficient
> lock-free solution for user space telemetry applications to pull the
> statistics data periodically for large scale systems. The pulling
> frequency could be as high as a few times per second.
> In this patchset, every statistics data are treated to have some
> attributes as below:
>    * architecture dependent or generic
>    * VM statistics data or VCPU statistics data
>    * type: cumulative, instantaneous,
>    * unit: none for simple counter, nanosecond, microsecond,
>      millisecond, second, Byte, KiByte, MiByte, GiByte. Clock Cycles
> Since no lock/synchronization is used, the consistency between all
> the statistics data is not guaranteed. That means not all statistics
> data are read out at the exact same time, since the statistics date
> are still being updated by KVM subsystems while they are read out.

The binary interface itself looks good.  Can you do a follow-up patch to 
remove struct kvm_stats_debugfs_item and avoid the duplication?  I'd 
rather have that too before committing the code.

Thanks,

Paolo

