Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 332B2132B4A
	for <lists+kvm-ppc@lfdr.de>; Tue,  7 Jan 2020 17:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgAGQqG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 7 Jan 2020 11:46:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35216 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727559AbgAGQqG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 7 Jan 2020 11:46:06 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 007GbsPD042894
        for <kvm-ppc@vger.kernel.org>; Tue, 7 Jan 2020 11:46:05 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xar493k73-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 07 Jan 2020 11:46:05 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Tue, 7 Jan 2020 16:46:03 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 7 Jan 2020 16:46:01 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 007GjCQf48955768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jan 2020 16:45:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC196A4054;
        Tue,  7 Jan 2020 16:45:59 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1B0BA405B;
        Tue,  7 Jan 2020 16:45:57 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.80.219.96])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  7 Jan 2020 16:45:57 +0000 (GMT)
Date:   Tue, 7 Jan 2020 08:45:54 -0800
From:   Ram Pai <linuxram@us.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>, bharata@linux.ibm.com,
        linuxppc-dev@ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v4 2/2] KVM: PPC: Implement H_SVM_INIT_ABORT hcall
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20191219215146.27278-1-sukadev@linux.ibm.com>
 <20191219215146.27278-2-sukadev@linux.ibm.com>
 <20200103203712.GG5556@oc0525413822.ibm.com>
 <20200107020237.GA29843@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107020237.GA29843@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20010716-0016-0000-0000-000002DB3BB5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010716-0017-0000-0000-0000333DB397
Message-Id: <20200107164554.GA5419@oc0525413822.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-07_05:2020-01-07,2020-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=815 impostorscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 clxscore=1015 bulkscore=0 phishscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001070136
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jan 06, 2020 at 06:02:37PM -0800, Sukadev Bhattiprolu wrote:
> Ram Pai [linuxram@us.ibm.com] wrote:
> >
> > One small comment.. H_STATE is a better return code than H_UNSUPPORTED.
> > 
> 
> Here is the updated patch - we now return H_STATE if the abort call is
> made after the VM has gone secure.
> ---
> >From 73fe1fa5aff2829f2fae6a339169e56dc0bbae06 Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> Date: Fri, 27 Sep 2019 14:30:36 -0500
> Subject: [PATCH 2/2] KVM: PPC: Implement H_SVM_INIT_ABORT hcall

This patch looks good.

Reviewed-by: Ram Pai <linuxram@us.ibm.com>

Thanks,
RP

