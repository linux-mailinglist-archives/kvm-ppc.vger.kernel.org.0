Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623FA3E8E69
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 12:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbhHKKUx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 06:20:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237042AbhHKKUv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 06:20:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628677228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vzNKS8jqyPAaVafnIpkch354MYvVZeHaPB5KNR7T5Mk=;
        b=QklKDRRzf37TfvFdY2/KDuz1VD1C7CJ4c60D0Y/YmlSXwc9iq6wKZsCG2UKju1q4pct+ju
        EBpGZc17g9iwoPTsqx8yaPnvS6gsTH856mDWYJtvme8froQWIJl0GuDPLqldqqjYWNJB8L
        HypZvjYPZquT/kmDZD45qyDZmKdZ1Ec=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-gFePf-9tMGG0x8ILJKH0jA-1; Wed, 11 Aug 2021 06:20:26 -0400
X-MC-Unique: gFePf-9tMGG0x8ILJKH0jA-1
Received: by mail-ej1-f71.google.com with SMTP id h17-20020a1709070b11b02905b5ced62193so502163ejl.1
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 03:20:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vzNKS8jqyPAaVafnIpkch354MYvVZeHaPB5KNR7T5Mk=;
        b=P6uHiFgp1qxBk2ssBUQDtmVe+8eFiZaVfZLk0M3dqA4sQsoAjk+G/tTerrs6Edvvsf
         n787QnSxvejVXsDSzIDIhJoIf92jaiQ/SRHwqCMobVwTDsHaCfxiQCxVzA+SXwagnnSY
         dq/rzwxyQq52lLbKn4ylGPMxwZ+WRTbPPbSAIyqdhPKe0I8dloplOptakXWUUMbzxQsI
         WFggYzuR9iQcjLpJ/upAP0rko39CWPoNaMS8LCmn6nt6UnuPXRArNe1RTyNu/mW+Eyz1
         mh5ekrYrEuQ+8tfIcYsnhTlzC967Com4yZSLqD7fZoDcWsMexKrvzLndS7fgKVDkP9Eu
         Ze5w==
X-Gm-Message-State: AOAM532Nkp4SlnUpXjWwRn3rZ/ck321eUY4OOeGwk2RZcxmiT7VnuPiN
        Pd7E7YqgdzgHRIeFe/P0GadtC/8KEz9dTr4LfPndb9kmFi2IXN/7VhHE4b5BJQxjb+xsW+CTBA+
        td+U5Xk/BJN36vWHKlQ==
X-Received: by 2002:a17:906:4894:: with SMTP id v20mr2827811ejq.207.1628677225535;
        Wed, 11 Aug 2021 03:20:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXkrdffhPe4tXy3ltmqSJ6w5dqsU7sFWQYmUfpZ2KuloIV5wPgIeCZgjPaG/bAnd/2u6dxIw==
X-Received: by 2002:a17:906:4894:: with SMTP id v20mr2827802ejq.207.1628677225342;
        Wed, 11 Aug 2021 03:20:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id f8sm2120747edy.57.2021.08.11.03.20.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 03:20:24 -0700 (PDT)
Subject: Re: [PATCH] KVM: stats: Add VM dirty_pages stats for the number of
 dirty pages
To:     Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Peter Feiner <pfeiner@google.com>
References: <20210810223238.979194-1-jingzhangos@google.com>
 <CAOQ_QshcSQWhEUt9d7OV58V=3WrL34xfpFYS-wp6H4rzy_r_4w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5183cb08-f739-e6a6-f645-3ccbe92d04d8@redhat.com>
Date:   Wed, 11 Aug 2021 12:20:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAOQ_QshcSQWhEUt9d7OV58V=3WrL34xfpFYS-wp6H4rzy_r_4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 11/08/21 00:56, Oliver Upton wrote:
> What if the statistic was 'dirtied_pages', which records the number of
> pages dirtied in the lifetime of a VM? Userspace could just record the
> value each time it blows away the dirty bitmaps and subtract that
> value next time it reads the stat. It would circumvent the need to
> walk the entire dirty bitmap to keep the statistic sane.

Yeah, that'd be much better also because the "number of dirty pages" 
statistic is not well defined in init-all-dirty mode.

Making it a vCPU stat works in fact, because mark_page_dirty_in_slot is 
only called with kvm_get_running_vcpu() != NULL; see 
kvm_dirty_ring_get() in virt/kvm/dirty_ring.c.

>>
>> +               if (kvm->dirty_ring_size) {
>>                         kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
>>                                             slot, rel_gfn);
>> -               else
>> +               } else {
>>                         set_bit_le(rel_gfn, memslot->dirty_bitmap);
>> +                       ++kvm->stat.generic.dirty_pages;
>> +               }
> 
> Aren't pages being pushed out to the dirty ring just as dirty? 
> 

Yes, they are.

Paolo

