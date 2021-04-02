Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848C8352C08
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Apr 2021 18:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbhDBO7u (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 2 Apr 2021 10:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235228AbhDBO7t (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 2 Apr 2021 10:59:49 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A672C061788
        for <kvm-ppc@vger.kernel.org>; Fri,  2 Apr 2021 07:59:47 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id v8so2619762plz.10
        for <kvm-ppc@vger.kernel.org>; Fri, 02 Apr 2021 07:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XauO+Tpx/QqvLfsNf0EieVcjgezYHlrLlZApCjoCcwc=;
        b=Tzgme0UQBGKuB+zSlD0xeHc77Hy6oWyrRyYiRZQFSKSope2ZlQuprlNPAFIGno9HCF
         19mRDkj5ZlfoNjs328k6GhD8eNbfCsQBcei3BTgXY+lndiulxllK9urmRZpNbnawPSHF
         1VntLWcNLRE/v2TUKfmWJP3RUU9JLl2aM0LmT3koOB9K6//ZWjl40DmwLdcbMuXOftRy
         vY7bpTZFLIxlRDiIvxlrah94VXX6FYPLZOMp+MPalyOIzbjG3+pDcx1vJhHFGSEmzlRs
         VifckWbHZsxI2muXBZVeIADxXGgNHUOjgsjNw0sHYg1S4nsynZoWCREOXUk86kfL7DYo
         Pc7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XauO+Tpx/QqvLfsNf0EieVcjgezYHlrLlZApCjoCcwc=;
        b=MQsi0sLRFdZqCtnVvuF7fA1GxCJCJDUnU53hX8k8Ylk1iRjllKIG14RCvoQehSgdNQ
         jCJcm03E94mhW60qK+hIguzEbESkbSF5nj/F9bwcpaGoUNDv0BQ7hPzqJQlhqFjnd33N
         IDo5Ez7iD3ENz25PfAHuJOFJMRWhkUOL/AVfzxIpg7pyVCr+0UU9m01x/meB4lHYkW0o
         dy0BLDaWSsWxJuRsArBZxi7zA4QLBxF8Hl/E9e9ZNwqgvSf+7Xv0chhjgHsDMn4wiqmY
         ehuhijsVAbohmFXMnC2QZQfdWq0u3+xctwTDmb/ZenCSiHhbKE6Ah6MO+lZi0zinpw0x
         qIVA==
X-Gm-Message-State: AOAM531tmcd52bnMkMQ3O5cFP3xNgVIEq0GVu5B+Do10XAWPDK9K9nem
        U8P7FB9eG1YepSSSEfZ8HyjQeg==
X-Google-Smtp-Source: ABdhPJxioQlQNRTARxdEppiGDcKbsI4noyv87TJnoDznkG+oVESSh/n5TV8EGFMcsMJo2RSOZZ0Vdg==
X-Received: by 2002:a17:90a:b889:: with SMTP id o9mr14181347pjr.97.1617375586898;
        Fri, 02 Apr 2021 07:59:46 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id n24sm8673883pgl.27.2021.04.02.07.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 07:59:46 -0700 (PDT)
Date:   Fri, 2 Apr 2021 14:59:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 07/10] KVM: Move MMU notifier's mmu_lock acquisition
 into common helper
Message-ID: <YGcxXvrluFJ+7o9X@google.com>
References: <20210402005658.3024832-1-seanjc@google.com>
 <20210402005658.3024832-8-seanjc@google.com>
 <a30f556a-40b2-f703-f0ee-b985989ee4b7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a30f556a-40b2-f703-f0ee-b985989ee4b7@redhat.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Apr 02, 2021, Paolo Bonzini wrote:
> On 02/04/21 02:56, Sean Christopherson wrote:
> > +		.handler	= (void *)kvm_null_fn,
> > +		.on_lock	= kvm_dec_notifier_count,
> > +		.flush_on_ret	= true,
> 
> Doesn't really matter since the handler is null, but I think it's cleaner to
> have false here.

Agreed.
