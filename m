Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115AE6CF42
	for <lists+kvm-ppc@lfdr.de>; Thu, 18 Jul 2019 15:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfGRN4m (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 18 Jul 2019 09:56:42 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:51437 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbfGRN4m (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 18 Jul 2019 09:56:42 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 45qFzq6mgpz9sDQ; Thu, 18 Jul 2019 23:56:39 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: da0ef93310e67ae6902efded60b6724dab27a5d1
In-Reply-To: <20190710052018.14628-1-sjitindarsingh@gmail.com>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     sjitindarsingh@gmail.com, kvm-ppc@vger.kernel.org,
        david@gibson.dropbear.id.au
Subject: Re: [PATCH] powerpc: mm: Limit rma_size to 1TB when running without HV mode
Message-Id: <45qFzq6mgpz9sDQ@ozlabs.org>
Date:   Thu, 18 Jul 2019 23:56:39 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 2019-07-10 at 05:20:18 UTC, Suraj Jitindar Singh wrote:
> The virtual real mode addressing (VRMA) mechanism is used when a
> partition is using HPT (Hash Page Table) translation and performs
> real mode accesses (MSR[IR|DR] = 0) in non-hypervisor mode. In this
> mode effective address bits 0:23 are treated as zero (i.e. the access
> is aliased to 0) and the access is performed using an implicit 1TB SLB
> entry.
> 
> The size of the RMA (Real Memory Area) is communicated to the guest as
> the size of the first memory region in the device tree. And because of
> the mechanism described above can be expected to not exceed 1TB. In the
> event that the host erroneously represents the RMA as being larger than
> 1TB, guest accesses in real mode to memory addresses above 1TB will be
> aliased down to below 1TB. This means that a memory access performed in
> real mode may differ to one performed in virtual mode for the same memory
> address, which would likely have unintended consequences.
> 
> To avoid this outcome have the guest explicitly limit the size of the
> RMA to the current maximum, which is 1TB. This means that even if the
> first memory block is larger than 1TB, only the first 1TB should be
> accessed in real mode.
> 
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> Tested-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
> Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

Applied to powerpc fixes, thanks.

https://git.kernel.org/powerpc/c/da0ef93310e67ae6902efded60b6724dab27a5d1

cheers
