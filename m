Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83413228F7E
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 Jul 2020 07:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgGVFCi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 22 Jul 2020 01:02:38 -0400
Received: from ozlabs.org ([203.11.71.1]:44525 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgGVFCi (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 22 Jul 2020 01:02:38 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4BBNcr48VYz9sSt; Wed, 22 Jul 2020 15:02:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1595394156; bh=YtTRfCV4UahyLx9Af7pCCXJP0N0KNpM91guqaVdDXQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LuLH3ggsM3xwahl7ZiSsX9oFJRX5yuR2rs95boy0b/VEmM5uv7WAPLe0YCwUjsmyg
         Gc4M0C6UTeVY/mWM8YN0SzosJEf1HX6ovVos38OPQmtj+TPgxLCE76N0nsE3xfEmib
         SxwYzRrK4gPu9Xk9NdlJMXNOGooqPxZiqMCYAzlw7NVA5WIMSrggqfquvC56UOny1C
         CA8S/gwWo5ALj8KW2/+X8FcAPkKgEYHQ+7+v+44FHkKI/uopHf1Y2HE98OiybQjcdf
         1ewhngXHg1iVwpeSqc3iDsmc6RW+3clDpp9GMeZ9+6D8WrMSOzBsgF59pDi3M95HVa
         GUOm/hlnoIkfQ==
Date:   Wed, 22 Jul 2020 15:02:32 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, sukadev@linux.vnet.ibm.com,
        ldufour@linux.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au, sathnaga@linux.vnet.ibm.com,
        aik@ozlabs.ru
Subject: Re: [RFC PATCH] powerpc/pseries/svm: capture instruction faulting on
 MMIO access, in sprg0 register
Message-ID: <20200722050232.GD3878639@thinks.paulus.ozlabs.org>
References: <1594888333-9370-1-git-send-email-linuxram@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594888333-9370-1-git-send-email-linuxram@us.ibm.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jul 16, 2020 at 01:32:13AM -0700, Ram Pai wrote:
> An instruction accessing a mmio address, generates a HDSI fault.  This fault is
> appropriately handled by the Hypervisor.  However in the case of secureVMs, the
> fault is delivered to the ultravisor.
> 
> Unfortunately the Ultravisor has no correct-way to fetch the faulting
> instruction. The PEF architecture does not allow Ultravisor to enable MMU
> translation. Walking the two level page table to read the instruction can race
> with other vcpus modifying the SVM's process scoped page table.
> 
> This problem can be correctly solved with some help from the kernel.
> 
> Capture the faulting instruction in SPRG0 register, before executing the
> faulting instruction. This enables the ultravisor to easily procure the
> faulting instruction and emulate it.

Just a comment on the approach of putting the instruction in SPRG0:
these I/O accessors can be used in interrupt routines, which means
that if these accessors are ever used with interrupts enabled, there
is the possibility of an external interrupt occurring between the
instruction that sets SPRG0 and the load/store instruction that
faults.  If the handler for that interrupt itself does an I/O access,
it will overwrite SPRG0, corrupting the value set by the interrupted
code.

The choices to fix that would seem to be (a) disable interrupts around
all I/O accesses, (b) have the accessor save and restore SPRG0, or (c)
solve the problem another way, such as by doing a H_LOGICAL_CI_LOAD
or H_LOGICAL_CI_STORE hypercall.

Paul.
