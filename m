Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFE6219BAE
	for <lists+kvm-ppc@lfdr.de>; Thu,  9 Jul 2020 11:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgGIJJL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 9 Jul 2020 05:09:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54674 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726122AbgGIJJL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 9 Jul 2020 05:09:11 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06991oZM039299;
        Thu, 9 Jul 2020 05:08:59 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 325kgxkj7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 05:08:59 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0699257T040716;
        Thu, 9 Jul 2020 05:08:59 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 325kgxkj77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 05:08:59 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06991wHq023945;
        Thu, 9 Jul 2020 09:08:57 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 325k2qravb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 09:08:57 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06997X4260096814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jul 2020 09:07:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E556C11C05E;
        Thu,  9 Jul 2020 09:08:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A628011C05B;
        Thu,  9 Jul 2020 09:08:53 +0000 (GMT)
Received: from in.ibm.com (unknown [9.77.195.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  9 Jul 2020 09:08:53 +0000 (GMT)
Date:   Thu, 9 Jul 2020 14:38:51 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au
Subject: Re: [RFC PATCH v0 2/2] KVM: PPC: Book3S HV: Use H_RPT_INVALIDATE in
 nested KVM
Message-ID: <20200709090851.GD7902@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <20200703104420.21349-1-bharata@linux.ibm.com>
 <20200703104420.21349-3-bharata@linux.ibm.com>
 <20200709051803.GC2822576@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709051803.GC2822576@thinks.paulus.ozlabs.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_04:2020-07-08,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 suspectscore=1 bulkscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxlogscore=687 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090068
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jul 09, 2020 at 03:18:03PM +1000, Paul Mackerras wrote:
> On Fri, Jul 03, 2020 at 04:14:20PM +0530, Bharata B Rao wrote:
> > In the nested KVM case, replace H_TLB_INVALIDATE by the new hcall
> > H_RPT_INVALIDATE if available. The availability of this hcall
> > is determined from "hcall-rpt-invalidate" string in ibm,hypertas-functions
> > DT property.
> 
> What are we going to use when nested KVM supports HPT guests at L2?
> L1 will need to do partition-scoped tlbies with R=0 via a hypercall,
> but H_RPT_INVALIDATE says in its name that it only handles radix
> page tables (i.e. R=1).

For L2 HPT guests, the old hcall is expected to work after it adds
support for R=0 case?

The new hcall should be advertised via ibm,hypertas-functions only
for radix guests I suppose.

Regards,
Bharata.
