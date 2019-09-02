Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA2AEA4D61
	for <lists+kvm-ppc@lfdr.de>; Mon,  2 Sep 2019 05:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbfIBDGR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 1 Sep 2019 23:06:17 -0400
Received: from ozlabs.org ([203.11.71.1]:42711 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729061AbfIBDGQ (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 1 Sep 2019 23:06:16 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 46MFN651G8z9sN1; Mon,  2 Sep 2019 13:06:14 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 250c6c31228d49f3b96855ec387cf37bbe7cb6a7
In-Reply-To: <20190822034838.27876-2-cclaudio@linux.ibm.com>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        kvm-ppc@vger.kernel.org, Bharata B Rao <bharata@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Ram Pai <linuxram@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Guerney Hunt <gdhh@linux.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>
Subject: Re: [PATCH v6 1/7] Documentation/powerpc: Ultravisor API
Message-Id: <46MFN651G8z9sN1@ozlabs.org>
Date:   Mon,  2 Sep 2019 13:06:14 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, 2019-08-22 at 03:48:32 UTC, Claudio Carvalho wrote:
> From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> 
> Protected Execution Facility (PEF) is an architectural change for
> POWER 9 that enables Secure Virtual Machines (SVMs). When enabled,
> PEF adds a new higher privileged mode, called Ultravisor mode, to POWER
> architecture. Along with the new mode there is new firmware called the
> Protected Execution Ultravisor (or Ultravisor for short).
> 
> POWER 9 DD2.3 chips (PVR=0x004e1203) or greater will be PEF-capable.
> 
> Attached documentation provides an overview of PEF and defines the API
> for various interfaces that must be implemented in the Ultravisor
> firmware as well as in the KVM Hypervisor.
> 
> Based on input from Mike Anderson, Thiago Bauermann, Claudio Carvalho,
> Ben Herrenschmidt, Guerney Hunt, Paul Mackerras.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> Signed-off-by: Ram Pai <linuxram@linux.ibm.com>
> Signed-off-by: Guerney Hunt <gdhh@linux.ibm.com>
> Reviewed-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> Reviewed-by: Michael Anderson <andmike@linux.ibm.com>
> Reviewed-by: Thiago Bauermann <bauerman@linux.ibm.com>
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>

Series applied to powerpc topic/ppc-kvm, thanks.

https://git.kernel.org/powerpc/c/250c6c31228d49f3b96855ec387cf37bbe7cb6a7

cheers
