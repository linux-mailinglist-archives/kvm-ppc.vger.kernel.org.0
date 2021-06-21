Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F7F3AF0A0
	for <lists+kvm-ppc@lfdr.de>; Mon, 21 Jun 2021 18:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhFUQvA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 21 Jun 2021 12:51:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33639 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232213AbhFUQtF (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 21 Jun 2021 12:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624294010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L4VUJXelLg7ZDO7Fl2bwXBKFHPY2LaqxWaruX+3FsXM=;
        b=f2uaw0H11sSKRzF71e+2BnzTpOuZ3vpFQDGYuIHatLjr9ZpjLbrIeiEnMw54CJAivEpBLt
        7j99jhflwXwpdbfgVagAW9n/kb6IWhHcaCLktzsiVLoYZ5EWPvRy/ysNNtyx8KJhIMlMD2
        zvLvBCSJ80AfmvsXLyBqeInBP7Syy4M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-zD6YtCYPMeOEC1Scm_whEA-1; Mon, 21 Jun 2021 12:46:49 -0400
X-MC-Unique: zD6YtCYPMeOEC1Scm_whEA-1
Received: by mail-wm1-f70.google.com with SMTP id t11-20020a05600c198bb02901bf95ba8642so6092237wmq.3
        for <kvm-ppc@vger.kernel.org>; Mon, 21 Jun 2021 09:46:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L4VUJXelLg7ZDO7Fl2bwXBKFHPY2LaqxWaruX+3FsXM=;
        b=GP4VDsGZlA35HghRsZD9zgtGKjDCXIO0V/xqRleVENklIuocAPPaZv0k7YHDfoa4vm
         ch0vWe+tn4W8aGw8bjTuO5la1z2ptwgiPX516NQLfKWBNdWXu1wPbdxtwzYoo0thOwVf
         x2f5/HwaqtbBDotKt29VE9CBTAIg66SbTg/5XSKGlPCHQGpGHYx//IfabrFFWOk+Kg+6
         Aa8XbXxNa0TR8d6BsglNlXagNw544YDYfrnEi2Thc072cn7VGX6OrhIdCgsivWD0LChR
         HlUtS0Rs5/0Ti/EK/jY8+0wXCCTESE+t2qSwqH7F4BLLmTNiqavUMbdycEwnZ2iIkf+G
         HuJg==
X-Gm-Message-State: AOAM532mLILoFcMNy+qBq4pgIBqBcRJSn8RUvVZhQjXDfKaystT9lnp6
        8Tv7mxV5MTadLX6RSB00IBcIdDJW7PsZmGHyzZBR3cmMg60Rti/D9eKTaFkYgYNfzI4ilD9dLyV
        Qlh3E5jr2c07f56rBDA==
X-Received: by 2002:a1c:9a4b:: with SMTP id c72mr28275171wme.103.1624294008273;
        Mon, 21 Jun 2021 09:46:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFHH5+7/D7vjINDjeXsFlLSfp/qFoecAKuxzghrdq/ZeJStCXx4u1i/d7WztJFV77gL5prbw==
X-Received: by 2002:a1c:9a4b:: with SMTP id c72mr28275119wme.103.1624294008036;
        Mon, 21 Jun 2021 09:46:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a24sm16809099wmj.30.2021.06.21.09.46.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 09:46:47 -0700 (PDT)
Subject: Re: [PATCH v12 4/7] KVM: stats: Support binary stats retrieval for a
 VCPU
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
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Fuad Tabba <tabba@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
References: <20210618222709.1858088-1-jingzhangos@google.com>
 <20210618222709.1858088-5-jingzhangos@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d8bb52e6-3d1c-7008-388f-699f1a872e80@redhat.com>
Date:   Mon, 21 Jun 2021 18:46:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210618222709.1858088-5-jingzhangos@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 19/06/21 00:27, Jing Zhang wrote:
> +	struct kvm_vcpu_stat stat;
>   	struct kvm_dirty_ring dirty_ring;
> +	char stats_id[KVM_STATS_NAME_SIZE];

I think stats_id needs to be part of the usercopy region too.

You can also use

offsetofend(struct kvm_vcpu, stats_id) - offsetof(struct kvm_vcpu, arch)

to compute the size.

Paolo

