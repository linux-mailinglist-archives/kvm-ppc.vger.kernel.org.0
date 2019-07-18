Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCC76CF41
	for <lists+kvm-ppc@lfdr.de>; Thu, 18 Jul 2019 15:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfGRN4l (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 18 Jul 2019 09:56:41 -0400
Received: from ozlabs.org ([203.11.71.1]:33559 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbfGRN4k (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 18 Jul 2019 09:56:40 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 45qFzp31PNz9sBt; Thu, 18 Jul 2019 23:56:38 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 63279eeb7f93abb1692573c26f1e038e1a87358b
In-Reply-To: <20190703012022.15644-1-sjitindarsingh@gmail.com>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     sjitindarsingh@gmail.com, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: PPC: Book3S HV: Always save guest pmu for guest capable of nesting
Message-Id: <45qFzp31PNz9sBt@ozlabs.org>
Date:   Thu, 18 Jul 2019 23:56:38 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 2019-07-03 at 01:20:20 UTC, Suraj Jitindar Singh wrote:
> The performance monitoring unit (PMU) registers are saved on guest exit
> when the guest has set the pmcregs_in_use flag in its lppaca, if it
> exists, or unconditionally if it doesn't. If a nested guest is being
> run then the hypervisor doesn't, and in most cases can't, know if the
> pmu registers are in use since it doesn't know the location of the lppaca
> for the nested guest, although it may have one for its immediate guest.
> This results in the values of these registers being lost across nested
> guest entry and exit in the case where the nested guest was making use
> of the performance monitoring facility while it's nested guest hypervisor
> wasn't.
> 
> Further more the hypervisor could interrupt a guest hypervisor between
> when it has loaded up the pmu registers and it calling H_ENTER_NESTED or
> between returning from the nested guest to the guest hypervisor and the
> guest hypervisor reading the pmu registers, in kvmhv_p9_guest_entry().
> This means that it isn't sufficient to just save the pmu registers when
> entering or exiting a nested guest, but that it is necessary to always
> save the pmu registers whenever a guest is capable of running nested guests
> to ensure the register values aren't lost in the context switch.
> 
> Ensure the pmu register values are preserved by always saving their
> value into the vcpu struct when a guest is capable of running nested
> guests.
> 
> This should have minimal performance impact however any impact can be
> avoided by booting a guest with "-machine pseries,cap-nested-hv=false"
> on the qemu commandline.
> 
> Fixes: 95a6432ce903 "KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests"
> 
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

Series applied to powerpc fixes, thanks.

https://git.kernel.org/powerpc/c/63279eeb7f93abb1692573c26f1e038e1a87358b

cheers
