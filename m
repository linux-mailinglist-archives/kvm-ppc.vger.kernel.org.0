Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3CA3D8E1D
	for <lists+kvm-ppc@lfdr.de>; Wed, 28 Jul 2021 14:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhG1MpR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 28 Jul 2021 08:45:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234771AbhG1MpQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 28 Jul 2021 08:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627476314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YGi9CBVNLAaz99KYoBpbnkJ8wllA/JPj30f2JKISKfA=;
        b=g/+n/g2hYYAt5pdt6Fjawc85wD02UondZGymRS+8XtBiSDqDsDnyt1ZNJxXjXAmziUTYeC
        RQyJv2TgfduBdbCXv/YgqWk1MoLXT4O8gfRcInc2uaC3RoBth7k01af/WLk610hxnTtRc6
        24zXfq8/EewPKxeMFdqw55MioAuK5L0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-z2V6K9cOPymsIIHdYlHwig-1; Wed, 28 Jul 2021 08:45:12 -0400
X-MC-Unique: z2V6K9cOPymsIIHdYlHwig-1
Received: by mail-wm1-f71.google.com with SMTP id r125-20020a1c2b830000b0290197a4be97b7so892478wmr.9
        for <kvm-ppc@vger.kernel.org>; Wed, 28 Jul 2021 05:45:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YGi9CBVNLAaz99KYoBpbnkJ8wllA/JPj30f2JKISKfA=;
        b=J5XEO+VNay1BIvIOAHB7bPoul8bD6MQqqaLc18bQmgVRFoVm8Z6lskAjkqq01ta0Ri
         bgKZFJqdk+hWB937B1uViDwZ9WYyr/OJdjDi6sdRN8+crhWKHpie4260+ehZ+mY634Na
         +S8OHa68ykd/4hPBpLkGhR657vJx7EJX8SomeUfIJBC7z6LJRu4VgzJsLbPZ14hk/1nB
         nf43CRdFISL7Hm/Privdi3eFzU+uVitiifE+hFxnosG4UeVHPrwc9w4iaGsQj0UMjM1r
         DXIieXc8h/80lEcyWoxwNBty/Py6WBlVtlUONC8sTYzB2ipGwC9qWfSKG94beDo+Gljf
         8uDw==
X-Gm-Message-State: AOAM5308D/h6jCx6DuRJyo8Xa34jHyV7g/AiHsSlImkRSjgxPjxH+5gW
        kIHT5S4hpIitXwyb1QGQP85z0K+nP/RdARYlV9i2HaVGPLJoeGPaN7R5/IHUGIj1iHHgDWCUUu/
        H6qRNEkXboYHjIQUB+g==
X-Received: by 2002:a05:600c:4108:: with SMTP id j8mr8951332wmi.67.1627476311725;
        Wed, 28 Jul 2021 05:45:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyB4+vpCIDwC4RTUR6fM2EjrBVgNWRiaPrkQPVWgoV2R0S/+hHfBAHdBCDBCRvnQET/39AbhQ==
X-Received: by 2002:a05:600c:4108:: with SMTP id j8mr8951306wmi.67.1627476311554;
        Wed, 28 Jul 2021 05:45:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u15sm5974689wmn.6.2021.07.28.05.45.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 05:45:11 -0700 (PDT)
Subject: Re: [PATCH v1 4/4] KVM: stats: Add halt polling related histogram
 stats
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
References: <20210706180350.2838127-1-jingzhangos@google.com>
 <20210706180350.2838127-5-jingzhangos@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8a6f9314-7329-54d1-63b4-dc7ba6b4ea1d@redhat.com>
Date:   Wed, 28 Jul 2021 14:45:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706180350.2838127-5-jingzhangos@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 06/07/21 20:03, Jing Zhang wrote:
> +		kvm_stats_log_hist_update(
> +				vc->runner->stat.generic.halt_wait_hist,
> +				LOGHIST_SIZE_LARGE,
> +				ktime_to_ns(cur) - ktime_to_ns(start_wait));

Instead of passing the size to the function, perhaps you can wrap it 
with a macro

#define KVM_STATS_LOG_HIST_UPDATE(array, value) \
     kvm_stats_log_hist_update(array, ARRAY_SIZE(array), value)

Paolo

