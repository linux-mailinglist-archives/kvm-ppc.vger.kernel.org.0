Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADDC21B0D0
	for <lists+kvm-ppc@lfdr.de>; Fri, 10 Jul 2020 09:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgGJH5K (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 10 Jul 2020 03:57:10 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55507 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726757AbgGJH5J (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 10 Jul 2020 03:57:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594367828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9UmlYK6TFkdH3M5DCGlsKdci4FjjHwdZByjtVurs5W4=;
        b=EJrDQNXgkCZvp3P1S26jEFVkS/Q4nEZ8uzLJIYsCfrdMZ4XFGlzrD4OWILXaxzf9NyFelf
        13L7wR5JPc1BQ6mEy6G6lv7p5P0DtVcpuuCZZg9KoHLBsN93YZbpLVZgOBpVnilAK7kecT
        mg5SfUoFIqME+4VPgA0JVqmt7fb/v68=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-p-ACPECBOzWg2-GeJRObhg-1; Fri, 10 Jul 2020 03:57:06 -0400
X-MC-Unique: p-ACPECBOzWg2-GeJRObhg-1
Received: by mail-wr1-f70.google.com with SMTP id f5so5034616wrv.22
        for <kvm-ppc@vger.kernel.org>; Fri, 10 Jul 2020 00:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9UmlYK6TFkdH3M5DCGlsKdci4FjjHwdZByjtVurs5W4=;
        b=MZsFAz1utgJbX+N+pRJOwBehekb02E7TqWOKKs0XD+3adGFMIrdXC2wG/Whax8e1Vr
         OQAR9flHKnlCRzpjGfLfbt+cv1z56ecTODCgDIEWfr40SZqYQX0yx2iKSmQFeP05fBvs
         S2mQLfNCHMGfjBYSfCDVPUExXmUgcRqUtZCl7wSfCuhtIBDOjZv5ToklCgxIti3Wi1PF
         6SrgzKiiToI9cXmRv7nhg9YRw1LJqkj4hwU5MRGReDkNs4xNHPmZPgCKfwYnNzM4s7Q9
         L+Mh8Zy+vfLjRcOq4uOcURSEr1HKLQSMZw4ejW/MRAH9Tsa+2LPtKk38J7mjccFW5J9k
         nfDQ==
X-Gm-Message-State: AOAM533KqmxDzijPr3auVj3073gP3PAYFscpXnDQMceSN7Aae+l0TRQ6
        MwrUQJwqrIMkiwznWEWO94Sp9UOxGFpeL07U6yWIy80e8wD7OnELGGsnFrOFe0liZ+Y7uK6ZUpC
        xW7pZYaqeqd4eksPpyw==
X-Received: by 2002:a05:6000:d0:: with SMTP id q16mr35612069wrx.166.1594367825617;
        Fri, 10 Jul 2020 00:57:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlW3Ot+LBMZYtqgHl9fPkIYjtKMwBy9LJ/7SxUDFXEtvSCRy05DGSOlP3Hhmft1U2EXpdY3Q==
X-Received: by 2002:a05:6000:d0:: with SMTP id q16mr35612051wrx.166.1594367825324;
        Fri, 10 Jul 2020 00:57:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id 138sm23193764wmb.1.2020.07.10.00.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 00:57:04 -0700 (PDT)
Subject: Re: [PATCH v6 3/5] KVM: PPC: clean up redundant kvm_run parameters in
 assembly
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        tsbogend@alpha.franken.de, paulus@ozlabs.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
        chenhuacai@gmail.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200623131418.31473-1-tianjia.zhang@linux.alibaba.com>
 <20200623131418.31473-4-tianjia.zhang@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8947174f-ce16-c076-e208-55e743d9fdf0@redhat.com>
Date:   Fri, 10 Jul 2020 09:57:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200623131418.31473-4-tianjia.zhang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 23/06/20 15:14, Tianjia Zhang wrote:
>  
>  	/* Load non-volatile guest state from the vcpu */
> -	VCPU_LOAD_NVGPRS(r4)
> +	VCPU_LOAD_NVGPRS(r3)
>  
>  kvm_start_lightweight:
>  	/* Copy registers into shadow vcpu so we can access them in real mode */
> -	mr	r3, r4
>  	bl	FUNC(kvmppc_copy_to_svcpu)
>  	nop
> -	REST_GPR(4, r1)
> +	REST_GPR(3, r1)
>  
>  #ifdef CONFIG_PPC_BOOK3S_64
>  	/* Get the dcbz32 flag */
> @@ -146,7 +144,7 @@ after_sprg3_load:

Below, there are a bunch of references to r3 and r4 left

        rldicl  r3, r3, 0, 63           /* r3 &= 1 */
        stb     r3, HSTATE_RESTORE_HID5(r13)

        /* Load up guest SPRG3 value, since it's user readable */
        lwz     r3, VCPU_SHAREDBE(r4)				  <<<
        cmpwi   r3, 0
        ld      r5, VCPU_SHARED(r4)				  <<<

where r3 is also destroyed.  So I'd rather have three patches:

- one that is as small as possible, changing the prototypes and adding

	mr r4, r3

- one that entirely swaps out r3 and r4.  This would be the hard one to
review!

- one that cleans up the prologue and epilogue

But overall I think it's simplest to just leave out this patch.

Paolo

