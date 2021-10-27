Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7994C43CD76
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Oct 2021 17:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242717AbhJ0PbB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 27 Oct 2021 11:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237611AbhJ0PbB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 27 Oct 2021 11:31:01 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1864C061570
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Oct 2021 08:28:35 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 83so3248300pgc.8
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Oct 2021 08:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jluBW5yA9LvugmQi8oyfDy8/cabbakiUXPqo4utsaB8=;
        b=IXIkAF60iwH8Ca28unKtkkjCxMxH4jsRE7rdlyRpHRKxqRH5DKvzKzXeE1xZpeP67E
         xwOJxCxtNAW/vuRZ9/cA++xLC0bu82EJesdjjIouYVg3x2VESqFJeksK7bKKBVif038n
         GNlri9Hc+F1u7CW4lPLn9JPRn52da4aBC4xsr93HTbSLq1yGzKbznkaiM+WfpWPTb1nX
         8Hjyo7QQx66GQF0REMEMDncs7WF5cqEgNENljeKIdAyawTn2njGp/q6Q7uPOzyYDFpEX
         mqf5isD4pvLAp694w88H9zUwbgY74QXFwiejeE2dZlhZt757K0HlOnfUIVAivKet6eGr
         4Dpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jluBW5yA9LvugmQi8oyfDy8/cabbakiUXPqo4utsaB8=;
        b=trmT5vZ3FyISOgXL7unflQigbMYHg3R8WBJ+j9U4NUsY6wj9zhJLBgyTwzS++HWd52
         zKEeNb0UGPuzonBHfG/l25hDI/hJNw16+3+5NrNmXeItRvn6S64KkiQjRcdlliAVn1js
         OuWGKaodfMZ6yryyBCRqSt+YVSkmQbbq1Ti39jvkYfAV4FysyPBjMKlSKwBD1Pe4YJq1
         mRz2cgDdx3WqPJ0hIkRukpsGyrAhEWydRWdf5ESHWErJeXl6EvWcMBJo48ht4+dhiKfL
         Ab+ptm1u23JP3Ud5OeO1b0e7xtHcpFpm5HvqE6S5ifyp/6GE2UT1Drrk4+rpeVLZ3B4o
         VsCA==
X-Gm-Message-State: AOAM531cQzxdYLbhfAZo2ZJE/KspzbBiYa1qMiwySAhPx9F3NROJOv1q
        VVpZbeS5tsp6T17itgKAxEbu7Q==
X-Google-Smtp-Source: ABdhPJxibfpJFn220g32tVsxXXYwD2JThHpi8b5HJLrZMbbjn5Hu0UDQk4ZV4kEcRQbC7q9gao3DeQ==
X-Received: by 2002:a05:6a00:2405:b0:44c:1ec3:8dbe with SMTP id z5-20020a056a00240500b0044c1ec38dbemr33619608pfh.33.1635348515143;
        Wed, 27 Oct 2021 08:28:35 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y19sm340714pfn.23.2021.10.27.08.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 08:28:34 -0700 (PDT)
Date:   Wed, 27 Oct 2021 15:28:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v2 00/43] KVM: Halt-polling and x86 APICv overhaul
Message-ID: <YXlwH2vWILFS9QOG@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <614858dd-106c-64cc-04bc-f1887b2054d1@redhat.com>
 <YXllGfrjPX1pVUx6@google.com>
 <ecec4d7d-13dd-c992-6648-3624d7c14c24@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecec4d7d-13dd-c992-6648-3624d7c14c24@redhat.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Oct 27, 2021, Paolo Bonzini wrote:
> On 27/10/21 16:41, Sean Christopherson wrote:
> > The other thing I don't like about having the WARN in the loop is that it suggests
> > that something other than the vCPU can modify the NDST and SN fields, which is
> > wrong and confusing (for me).
> 
> Yeah, I can agree with that.  Can you add it in a comment above the cmpxchg
> loop, it can be as simple as
> 
> 	/* The processor can set ON concurrently.  */
> 
> when you respin patch 21 and the rest of the series?

I can definitely add a comment, but I think that comment is incorrect.  AIUI,
the CPU is the one thing in the system that _doesn't_ set ON, at least not without
IPI virtualization (haven't read that spec yet).  KVM (software) sets it when
emulating IPIs, and the IOMMU (hardware) sets it for "real" posted interrupts,
but the CPU (sans IPI virtualization) only clears ON when processing an IRQ on
the notification vector.

So something like this?

	/* ON can be set concurrently by a different vCPU or by hardware. */
