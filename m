Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFEB36404D
	for <lists+kvm-ppc@lfdr.de>; Mon, 19 Apr 2021 13:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhDSLTC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 19 Apr 2021 07:19:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233615AbhDSLTB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 19 Apr 2021 07:19:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618831111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WCzp3qZIdr4u0FyN9JADLtQu47gdCQ0CxNrxY5TVo9Q=;
        b=hqH5z56A+2KAdcG0ulL8wAr6i+LU9GQxwyulGAD2m9k/c4kK0Rn58ugRuSfoAAGXvmj1vI
        FmZyCj265NKhxQ+RWn1NEnIIlB+WJAZMoRYMl3UMO3NdY1u4nvEb3e1BlYshUJ0YJuWwfy
        BhWO8TjSMIElIeRDVHxRc8gPlbFrSeY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-XL24tPm4N9G99xxlWWZo5Q-1; Mon, 19 Apr 2021 07:18:29 -0400
X-MC-Unique: XL24tPm4N9G99xxlWWZo5Q-1
Received: by mail-ed1-f71.google.com with SMTP id y10-20020a50f1ca0000b0290382d654f75eso10993380edl.1
        for <kvm-ppc@vger.kernel.org>; Mon, 19 Apr 2021 04:18:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WCzp3qZIdr4u0FyN9JADLtQu47gdCQ0CxNrxY5TVo9Q=;
        b=avyCpkLanXbiYVW4iuDxv7VyAfYoMoh0LyZ6tJU0FDZzCBqIzo6uXQvdA6NPyPZfiz
         0K6szjP8qgDoH1bSPYK1rhevs4iqJS52uGYmu6iTAQ+Ku7BV3FTAPFLvtEoaTAvRSZZG
         2WETV05Hn0PB+4HogVlFhOwmwF0jpZ1UgRkCcNscv+iPdO9gnvGK1VBhpgu89O+0PZZJ
         3k5eFG/vVzBcx8rt1aUXX75dTnk9eZtEtkU+60FzslGoEc1PLUjUkuamraV7qjoeqG18
         gIs6E9RZEUesNOeLqcbWFBPefasqOS4XAHKvEOGvCQgE+TPJvL3GMRSULateqL2XMPGB
         siJg==
X-Gm-Message-State: AOAM531PgzxF36OQavTTBx/bYfw5sXzPyrhwlG43WPP/eLQbpC0WIqub
        tR8Zy5vB8gS6hJwckyXrh3pEgHw79sG0HOkkQObRyAWCUKJ64Mfui1bkt6sY15V21385X+bHkE6
        KDK+iCyv8NS5cjmHgpg==
X-Received: by 2002:a17:906:1d0e:: with SMTP id n14mr21657017ejh.97.1618831108546;
        Mon, 19 Apr 2021 04:18:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqu63LOpqckc/b1y9M3cEHioz8UWECwAeoDEKHsVXD1WCUxtmmwnesWctc6sXbp3BngiuQvA==
X-Received: by 2002:a17:906:1d0e:: with SMTP id n14mr21656990ejh.97.1618831108376;
        Mon, 19 Apr 2021 04:18:28 -0700 (PDT)
Received: from localhost.localdomain ([194.230.155.160])
        by smtp.gmail.com with ESMTPSA id ck29sm12468881edb.47.2021.04.19.04.18.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 04:18:27 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] KVM: selftests: Add selftest for KVM statistics
 data binary interface
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        David Rientjes <rientjes@google.com>
References: <20210415151741.1607806-1-jingzhangos@google.com>
 <20210415151741.1607806-5-jingzhangos@google.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <9f2a8873-c2c2-ec84-58b4-7c90c59d1d25@redhat.com>
Date:   Mon, 19 Apr 2021 13:18:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210415151741.1607806-5-jingzhangos@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Jing,

> +int vm_stats_test(struct kvm_vm *vm)
> +{
> +	ssize_t ret;
> +	int i, stats_fd, err = -1;
> +	size_t size_desc, size_data = 0;
> +	struct kvm_stats_header header;
> +	struct kvm_stats_desc *stats_desc, *pdesc;
> +	struct kvm_vm_stats_data *stats_data;
> +
> +	// Get fd for VM stats

Another small nitpick: comments should go in /* */ format

Thank you,
Emanuele

