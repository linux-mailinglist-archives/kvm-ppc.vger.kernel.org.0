Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A2D373EFB
	for <lists+kvm-ppc@lfdr.de>; Wed,  5 May 2021 17:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbhEEPxK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 5 May 2021 11:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbhEEPxK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 5 May 2021 11:53:10 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B210EC06174A
        for <kvm-ppc@vger.kernel.org>; Wed,  5 May 2021 08:52:13 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id h7so1333858plt.1
        for <kvm-ppc@vger.kernel.org>; Wed, 05 May 2021 08:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fWu6RproSO3vhb8FFKdjOsNB26PtX2CgGoLpKJMkcZw=;
        b=dP4d1XGCVm58MZKh9tsvJLb4Si+Kcg4C0fRJSYNgI2AKkoDfsxnrTnesNUgLsPZAkn
         1XASzlm4f+ZoY70g7IizU8IwaIVMNMYgmjgEmMDHOhR1JdUml+F78Ev5iOIfVp/rTycF
         QTQX4a1jEg2olMfZ4M/CzhoW0fPaDCjhNbLLvfZg/gSQuHlnrxUNjUS+14Rtapq3Y7Y9
         IvTY6B8QWNbqkTugNkDTxqiVmqIU70IIZAUzuCiAX+jp51pL8aGQ5SgulkKLB2ayCtwQ
         kAILENZEsLLaAW80Cds2aMk4DHtH1VuLuvanm2/EfpAW8AN8uLvPAsWs2/xsCLIy0PgE
         Lg/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fWu6RproSO3vhb8FFKdjOsNB26PtX2CgGoLpKJMkcZw=;
        b=gzdtH8rfBfxokYDxbc39wH0wL/sAIf3XwgHSk78ShdTngLzHsTPKeiruVMnG52ijEy
         AYEVa895fFeMhkvwqtfwUGSLm/OKmxoEP5qxVqf4dmpHwyrRB8D3bEKrzAaYMwlcFtsB
         JUpysY62y1H6wCIAFXQCxniMkicLkvitwzdxUHqdtGVhZlhZJI2gngGxCLi896YaiZXc
         dFDMfHEl0ddopM4go4Gm5spZgcoz3ZdfcVegap+cWjaAjDcw9ZWFkP4Z4PKadefg9UqU
         ub9QczEK48QjOV7E3FSgR+/c7iPUxMAURoghElE7QcCWlVy5CWxGF88P2hVc98NVyBxK
         ouuA==
X-Gm-Message-State: AOAM533X+aGQshYCMBC3g31ajzAbortJ8CEeep3I7hgbRd79fvX8gETl
        TcA2go7SUzU3zKQkmFlIcf+v4w==
X-Google-Smtp-Source: ABdhPJwM38lKwE/g3ivwr6B32LLXTSqABMeye1jvL0UfKxvx1FlpoVNpsfmJhOTmB1Grke5kcamWNg==
X-Received: by 2002:a17:90a:f2cf:: with SMTP id gt15mr12025100pjb.64.1620229932814;
        Wed, 05 May 2021 08:52:12 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id r32sm6730235pgm.49.2021.05.05.08.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 08:52:12 -0700 (PDT)
Date:   Wed, 5 May 2021 15:52:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Bharata B Rao <bharata@linux.ibm.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix conversion to gfn-based MMU
 notifier callbacks
Message-ID: <YJK/KDCV5CvTNhoo@google.com>
References: <20210505121509.1470207-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505121509.1470207-1-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, May 05, 2021, Nicholas Piggin wrote:
> Commit b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU notifier
> callbacks") causes unmap_gfn_range and age_gfn callbacks to only work
> on the first gfn in the range. It also makes the aging callbacks call
> into both radix and hash aging functions for radix guests. Fix this.

Ugh, the rest of kvm_handle_hva_range() was so similar to the x86 code that I
glossed right over the for-loop.  My apologies :-/

> Add warnings for the single-gfn calls that have been converted to range
> callbacks, in case they ever receieve ranges greater than 1.
> 
> Fixes: b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU notifier callbacks")
> Reported-by: Bharata B Rao <bharata@linux.ibm.com>
> Tested-by: Bharata B Rao <bharata@linux.ibm.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
> The e500 change in that commit also looks suspicious, why is it okay
> to remove kvm_flush_remote_tlbs() there? Also is the the change from
> returning false to true intended?

The common code interprets a return of "true" as "do kvm_flush_remote_tlbs()".
There is technically a functional change, as the deferring the flush to common
code will batch flushes if the invalidation spans multiple memslots.  But the
mmu_lock is held the entire time, so batching is a good thing unless e500 has
wildly different MMU semantics.
