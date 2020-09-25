Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE637278EA5
	for <lists+kvm-ppc@lfdr.de>; Fri, 25 Sep 2020 18:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbgIYQdE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 25 Sep 2020 12:33:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727751AbgIYQdE (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 25 Sep 2020 12:33:04 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47BF620738;
        Fri, 25 Sep 2020 16:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601051583;
        bh=7TU9kWw58pJDNUxAQUELKat8AUx/OZ978xRwb3agCpM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Js1A7tFd/oLicRCBqR1juwwr+LzahGXkH9mcYss0ahUwkLD8XI5GX9B1I8D7+jbRe
         KinG0UfGCDKW9tzCSo++aA8F6dPT6YYt7eKwTKSEPmRf+5RMwtj7cmJ7Z14obKacnw
         GyuJ+Rm1/1IjepqtXCK1djDtnOxpzEbh5pHJLXRE=
Received: from [185.69.144.225] (helo=wait-a-minute.misterjones.org)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kLqeb-00Ev7R-9n; Fri, 25 Sep 2020 17:33:01 +0100
Date:   Fri, 25 Sep 2020 17:32:53 +0100
Message-ID: <874knlrf4a.wl-maz@kernel.org>
From:   Marc Zyngier <maz@kernel.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [RFC PATCH 0/3] KVM: Introduce "VM bugged" concept
In-Reply-To: <20200923224530.17735-1-sean.j.christopherson@intel.com>
References: <20200923224530.17735-1-sean.j.christopherson@intel.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL/10.8 EasyPG/1.0.0 Emacs/26.3
 (x86_64-pc-linux-gnu) MULE/6.0 (HANACHIRUSATO)
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.69.144.225
X-SA-Exim-Rcpt-To: sean.j.christopherson@intel.com, pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, chenhc@lemote.com, aleksandar.qemu.devel@gmail.com, linux-mips@vger.kernel.org, paulus@ozlabs.org, kvm-ppc@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Sean,

On Wed, 23 Sep 2020 23:45:27 +0100,
Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> 
> This series introduces a concept we've discussed a few times in x86 land.
> The crux of the problem is that x86 has a few cases where KVM could
> theoretically encounter a software or hardware bug deep in a call stack
> without any sane way to propagate the error out to userspace.
> 
> Another use case would be for scenarios where letting the VM live will
> do more harm than good, e.g. we've been using KVM_BUG_ON for early TDX
> enabling as botching anything related to secure paging all but guarantees
> there will be a flood of WARNs and error messages because lower level PTE
> operations will fail if an upper level operation failed.
> 
> The basic idea is to WARN_ONCE if a bug is encountered, kick all vCPUs out
> to userspace, and mark the VM as bugged so that no ioctls() can be issued
> on the VM or its devices/vCPUs.
> 
> RFC as I've done nowhere near enough testing to verify that rejecting the
> ioctls(), evicting running vCPUs, etc... works as intended.

I'm quite like the idea. However, I wonder whether preventing the
vcpus from re-entering the guest is enough. When something goes really
wrong, is it safe to allow the userspace process to terminate normally
and free the associated memory? And is it still safe to allow new VMs
to be started?

I can't really imagine a case where such extreme measures would be
necessary on arm64, but I thought I'd ask.

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.
