Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9367363A02
	for <lists+kvm-ppc@lfdr.de>; Mon, 19 Apr 2021 06:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237527AbhDSEF0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 19 Apr 2021 00:05:26 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:54971 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233632AbhDSEFI (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 19 Apr 2021 00:05:08 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4FNtVn0vzJz9vGd; Mon, 19 Apr 2021 14:04:32 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org, ellerman@au1.ibm.com,
        linux-nvdimm@lists.01.org, sbhat@linux.vnet.ibm.com,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        kvm-ppc@vger.kernel.org, aneesh.kumar@linux.ibm.com
Cc:     vaibhav@linux.ibm.com, linux-doc@vger.kernel.org
In-Reply-To: <161703936121.36.7260632399582101498.stgit@e1fbed493c87>
References: <161703936121.36.7260632399582101498.stgit@e1fbed493c87>
Subject: Re: [PATCH v3] powerpc/papr_scm: Implement support for H_SCM_FLUSH hcall
Message-Id: <161880478871.1398509.15555293343691434743.b4-ty@ellerman.id.au>
Date:   Mon, 19 Apr 2021 13:59:48 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 29 Mar 2021 13:36:43 -0400, Shivaprasad G Bhat wrote:
> Add support for ND_REGION_ASYNC capability if the device tree
> indicates 'ibm,hcall-flush-required' property in the NVDIMM node.
> Flush is done by issuing H_SCM_FLUSH hcall to the hypervisor.
> 
> If the flush request failed, the hypervisor is expected to
> to reflect the problem in the subsequent nvdimm H_SCM_HEALTH call.
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/papr_scm: Implement support for H_SCM_FLUSH hcall
      https://git.kernel.org/powerpc/c/75b7c05ebf902632f7f540c3eb0a8945c2d74aab

cheers
