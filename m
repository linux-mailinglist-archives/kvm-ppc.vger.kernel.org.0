Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4AAB22043A
	for <lists+kvm-ppc@lfdr.de>; Wed, 15 Jul 2020 07:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgGOFKG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 15 Jul 2020 01:10:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725880AbgGOFKG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 15 Jul 2020 01:10:06 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06F52YRo113552;
        Wed, 15 Jul 2020 01:09:55 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 328s0dw6mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 01:09:55 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06F54iui009072;
        Wed, 15 Jul 2020 05:09:52 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 327527v1u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 05:09:52 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06F59ohb45220004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 05:09:50 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3CB35204E;
        Wed, 15 Jul 2020 05:09:49 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.163.39.1])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 8BFC452051;
        Wed, 15 Jul 2020 05:09:46 +0000 (GMT)
Date:   Tue, 14 Jul 2020 22:09:43 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        aneesh.kumar@linux.ibm.com, sukadev@linux.vnet.ibm.com,
        ldufour@linux.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au, cclaudio@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: Re: [v3 4/5] KVM: PPC: Book3S HV: retry page migration before
 erroring-out H_SVM_PAGE_IN
Message-ID: <20200715050943.GD7339@oc0525413822.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1594458827-31866-1-git-send-email-linuxram@us.ibm.com>
 <1594458827-31866-5-git-send-email-linuxram@us.ibm.com>
 <20200713095043.GH7902@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713095043.GH7902@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_02:2020-07-14,2020-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=917
 lowpriorityscore=0 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150042
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jul 13, 2020 at 03:20:43PM +0530, Bharata B Rao wrote:
> On Sat, Jul 11, 2020 at 02:13:46AM -0700, Ram Pai wrote:
> > The page requested for page-in; sometimes, can have transient
> > references, and hence cannot migrate immediately. Retry a few times
> > before returning error.
> 
> As I noted in the previous patch, we need to understand what are these
> transient errors and they occur on what type of pages?

Its not clear when they occur. But they occur quite irregularly and they 
do occur on pages that were shared in the previous boot.

> 
> The previous patch also introduced a bit of retry logic in the
> page-in path. Can you consolidate the retry logic into a separate
> patch?

yes. having the retry logic in a seperate patch gives us the flexibility
to drop it, if needed.  The retry patch is not the core element of this
patch series.

RP
