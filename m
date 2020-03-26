Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9F9193E9A
	for <lists+kvm-ppc@lfdr.de>; Thu, 26 Mar 2020 13:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgCZMGv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 26 Mar 2020 08:06:51 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:32995 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728296AbgCZMGu (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 26 Mar 2020 08:06:50 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 48p3cm5vJ1z9sSL; Thu, 26 Mar 2020 23:06:48 +1100 (AEDT)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 74bb84e5117146fa73eb9d01305975c53022b3c3
In-Reply-To: <20200312074404.87293-1-aik@ozlabs.ru>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Ram Pai <linuxram@us.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH kernel] powerpc/prom_init: Pass the "os-term" message to hypervisor
Message-Id: <48p3cm5vJ1z9sSL@ozlabs.org>
Date:   Thu, 26 Mar 2020 23:06:48 +1100 (AEDT)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, 2020-03-12 at 07:44:04 UTC, Alexey Kardashevskiy wrote:
> The "os-term" RTAS calls has one argument with a message address of
> OS termination cause. rtas_os_term() already passes it but the recently
> added prom_init's version of that missed it; it also does not fill args
> correctly.
> 
> This passes the message address and initializes the number of arguments.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/74bb84e5117146fa73eb9d01305975c53022b3c3

cheers
