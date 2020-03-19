Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D01918C3C2
	for <lists+kvm-ppc@lfdr.de>; Fri, 20 Mar 2020 00:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgCSXer (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Mar 2020 19:34:47 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:36563 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgCSXer (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 19 Mar 2020 19:34:47 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 48k3Cm3QZgz9sSL; Fri, 20 Mar 2020 10:34:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1584660884; bh=LG8xa3mS/oJ94UFOhSt2KGXBPPU42IS8V/3vBwMyZ/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=okApgmuZWnbdSgXyMpMtt0Ag/byLSD5AFy8eQz8G5nuUs5kEs60eQBs0ktqfCnfih
         ilfkajX1ztYMWdMYeyI+j0w5jQDsuHWC7xOb7xZQAccxqr5JGueyfWtPv5nj7rFSlt
         PVjsyByaNGFBFXttYFegapoB+zlNhG9a++d6vj7M1PmgYcqSVVCr2FVYENuWZfRPnl
         pf80sFN6VBuIhTxBL8t/ckNSQgdXO6MmVgVwGXO9ErEpwfS4py5v8Ij3TSbjtAtP6w
         LVmzSt2gF+3avbt9maTtZGZFyGVDGHDWEFU5hDdFKmCr2b4qE/pIzw/afREjLT+af9
         +MTiv8dylJHOA==
Date:   Fri, 20 Mar 2020 10:34:34 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Greg Kurz <groug@kaod.org>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 0/3] KVM: PPC: Fix host kernel crash with PR KVM
Message-ID: <20200319233434.GF3260@blackberry>
References: <158455340419.178873.11399595021669446372.stgit@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158455340419.178873.11399595021669446372.stgit@bahia.lan>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Mar 18, 2020 at 06:43:24PM +0100, Greg Kurz wrote:
> Recent cleanup from Sean Christopherson introduced a use-after-free
> condition that crashes the kernel when shutting down the VM with
> PR KVM. It went unnoticed so far because PR isn't tested/used much
> these days (mostly used for nested on POWER8, not supported on POWER9
> where HV should be used for nested), and other KVM implementations for
> ppc are unaffected.
> 
> This all boils down to the fact that the path that frees the per-vCPU
> MMU data goes through a complex set of indirections. This obfuscates
> the code to the point that we didn't realize that the MMU data was
> now being freed too early. And worse, most of the indirection isn't
> needed because only PR KVM has some MMU data to free when the vCPU is
> destroyed.
> 
> Fix the issue (patch 1) and simplify the code (patch 2 and 3).

I have put this series in my kvm-ppc-next branch, and I believe
Michael Ellerman is putting patch 1 in his fixes branch so it gets
into 5.6.

Thanks,
Paul.
