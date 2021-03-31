Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E485350884
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 22:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhCaUwo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 16:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbhCaUwS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 31 Mar 2021 16:52:18 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62B1C06175F
        for <kvm-ppc@vger.kernel.org>; Wed, 31 Mar 2021 13:52:17 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so1919464pjv.1
        for <kvm-ppc@vger.kernel.org>; Wed, 31 Mar 2021 13:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yoJglSBv69WpXRq5eWsDMsVvLVSgKRL+uxkOtmCkPv4=;
        b=ADUqKKQ3BT9AZj97LO1eTtS3t9SA7Iz5Y9gKCHGjYiSKaRi0OjZsNbCEZHlTHVsUK2
         RNZXwtrgWGKiRwRERUqUQHhNjNE4avYwBTOHTNeXUrFuBOZpSNcUgsrOMnNOFrF4Qmmx
         O6VxlothBKh2mwj18o5erYydCBdLp41Jx1ACR3P2G4E6KTzIjQwXv0iNU/NOfDyTFFnS
         200CcWoWmbjT9IdQc2M/KYaGZJ9MQ4swwqQjH/lVhVw8kM/Yif9KbXdwfMKqqTFBCtHd
         qG+c+KtKeKb557k9yYsai7I+C2YdTVQm/TDzi18tNlIaNowK9yiwFIR0cMG4QxaUuNJ2
         ySUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yoJglSBv69WpXRq5eWsDMsVvLVSgKRL+uxkOtmCkPv4=;
        b=PS/oh2ghcyMqlQ7mXeESVXyqH9fknhibZvUeS7Jx7R/ivyD/BPjrW73eR4aB7Q5HgJ
         8iPfVnaaIWGEiCg+aNV67dHYzsAmotbSwm7DbE3sHv15S9fO1BKloaVTnEUntYhN7qgB
         JwqlnvspGZx83qlMPYNq9AOLwzFdLRmRzsdvT8RXWnL+l9J60Jj9rz2y5kv6kN4VPfhQ
         7mmJFMwsmcLUab/NNc7tesypXGEDd/ljS+3csYhxavmW6VtHqaNKMomM25Jy6g48OyHx
         TZNzZdP5iyOG+OAscloA/JkdC5teLAPd4nTiMrVvfP6wecmqEaEa04F+Byt4qQ17eGYJ
         xjqA==
X-Gm-Message-State: AOAM531zb4tFXWgGHPZJGb/us+zo7FZxv4vnG0s5kHycC+W8PlkJNZ37
        ubd6XbFQeD3tecYG0ogxkCzr6A==
X-Google-Smtp-Source: ABdhPJyf4HLSrowxJceov6XASpdTMiPhuzoLXLjATJzpx1nt33JVlntT/l7g0VYbcVhhGtzPXPv8aQ==
X-Received: by 2002:a17:902:d4cd:b029:e5:dd6d:f9b3 with SMTP id o13-20020a170902d4cdb02900e5dd6df9b3mr4527204plg.43.1617223936594;
        Wed, 31 Mar 2021 13:52:16 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id s28sm3246776pfd.155.2021.03.31.13.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 13:52:16 -0700 (PDT)
Date:   Wed, 31 Mar 2021 20:52:12 +0000
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
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <YGTg/AWdieMM/mS7@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Mar 31, 2021, Paolo Bonzini wrote:
> On 26/03/21 03:19, Sean Christopherson wrote:
> Also, related to the first part of the series, perhaps you could structure
> the series in a slightly different way:
> 
> 1) introduce the HVA walking API in common code, complete with on_lock and
> patch 15, so that you can use on_lock to increase mmu_notifier_seq
> 
> 2) then migrate all architectures including x86 to the new API
> 
> IOW, first half of patch 10 and all of patch 15; then the second half of
> patch 10; then patches 11-14.

100% agree with introducing on_lock separately from the conditional locking.

Not so sure about introducing conditional locking and then converting non-x86
archs.  I'd prefer to keep the conditional locking after arch conversion.
If something does go awry, it would be nice to be able to preciesly bisect to
the conditional locking.  Ditto if it needs to be reverted because it breaks an
arch.
